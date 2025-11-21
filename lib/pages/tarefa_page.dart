import 'package:flutter/material.dart';

enum Priority { high, medium, low }

class Task {
  String id;
  String text;
  Priority priority;
  bool done;

  Task({
    required this.id,
    required this.text,
    required this.priority,
    this.done = false,
  });
}

class TarefasPage extends StatefulWidget {
  final DateTime dia;
  const TarefasPage({super.key, required this.dia});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final List<Task> _items = [];

  Priority _selectedPriority = Priority.medium;

  String get _filtro => _searchController.text.trim().toLowerCase();

  @override
  void dispose() {
    _taskController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  int _compareTasks(Task a, Task b) {
    if (a.done != b.done) return a.done ? 1 : -1;
    return a.text.toLowerCase().compareTo(b.text.toLowerCase());
  }

  int _insertionIndex(Task t) {
    for (int i = 0; i < _items.length; i++) {
      if (_compareTasks(t, _items[i]) < 0) return i;
    }
    return _items.length;
  }

  void _addTask() {
    final text = _taskController.text.trim();
    if (text.isEmpty) return;

    final newTask = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      priority: _selectedPriority,
      done: false,
    );

    final idx = _insertionIndex(newTask);
    _items.insert(idx, newTask);

    _listKey.currentState?.insertItem(
      idx,
      duration: const Duration(milliseconds: 350),
    );

    _taskController.clear();
  }

  void _removeTaskAt(int index) {
    final removed = _items.removeAt(index);

    _listKey.currentState?.removeItem(
      index,
      (context, anim) => _buildItem(removed, anim, index),
      duration: const Duration(milliseconds: 300),
    );
  }

  void _toggleDone(Task t) {
    final oldIndex = _items.indexWhere((x) => x.id == t.id);
    if (oldIndex == -1) return;

    t.done = !t.done;

    _listKey.currentState?.removeItem(
      oldIndex,
      (context, anim) => _buildItem(t, anim, oldIndex),
      duration: const Duration(milliseconds: 250),
    );

    _items.removeAt(oldIndex);

    final newIndex = _insertionIndex(t);
    _items.insert(newIndex, t);

    Future.delayed(const Duration(milliseconds: 260), () {
      _listKey.currentState?.insertItem(newIndex);
      setState(() {});
    });
  }

  Color _priorityColor(Priority p) {
    switch (p) {
      case Priority.high:
        return Colors.redAccent;
      case Priority.medium:
        return Colors.amber;
      case Priority.low:
        return const Color.fromARGB(255, 19, 55, 255);
    }
  }

  Widget _buildItem(Task t, Animation<double> animation, int index) {
    final isDone = t.done;

    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ),
      child: FadeTransition(
        opacity: animation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDone
                  ? Colors.greenAccent.withValues(alpha: 0.4)
                  : _priorityColor(t.priority).withValues(alpha: 0.4),
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _priorityColor(
                t.priority,
              ).withValues(alpha: 0.18),
            ),
            title: Text(
              t.text,
              style: TextStyle(
                color: Colors.white,
                decoration: isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Row(
              children: [
                _buildTag(
                  isDone ? Colors.greenAccent : Colors.amberAccent,
                  isDone ? "Concluída" : "Pendente",
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                isDone ? Icons.delete : Icons.check_circle,
                color: isDone ? Colors.redAccent : Colors.greenAccent,
              ),
              onPressed: () {
                if (isDone) {
                  _removeTaskAt(index);
                } else {
                  _toggleDone(t);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(Color color, String text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          if (icon != null)
            Icon(icon, size: 13, color: color.withValues(alpha: 0.9)),
          if (icon != null) const SizedBox(width: 4),
          Text(text, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Tarefas",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/plano_fundo4.png", fit: BoxFit.cover),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 110),

                Text(
                  "${widget.dia.day.toString().padLeft(2, '0')}/"
                  "${widget.dia.month.toString().padLeft(2, '0')}/"
                  "${widget.dia.year}",
                  style: const TextStyle(
                    color: Color(0xFFE6D7B1),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                _buildSearchBar(),

                const SizedBox(height: 14),

                _buildPrioritySelector(),

                const SizedBox(height: 16),

                _buildAddTask(),

                const SizedBox(height: 12),

                Expanded(
                  child: AnimatedList(
                    key: _listKey,
                    initialItemCount: _items.length,
                    itemBuilder: (context, index, anim) {
                      final t = _items[index];
                      if (_filtro.isNotEmpty &&
                          !t.text.toLowerCase().contains(_filtro)) {
                        return const SizedBox.shrink();
                      }
                      return _buildItem(t, anim, index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "Pesquisar",
          hintStyle: TextStyle(color: Colors.white60),
          prefixIcon: Icon(Icons.search, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _priorityButton(Priority.high, Icons.priority_high, 'Alta'),
        const SizedBox(width: 10),
        _priorityButton(Priority.medium, Icons.label_important, 'Média'),
        const SizedBox(width: 10),
        _priorityButton(Priority.low, Icons.low_priority, 'Baixa'),
      ],
    );
  }

  Widget _buildAddTask() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _taskController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Nova tarefa...",
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        SizedBox(
          height: 46,
          width: 46,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: const Color(0xFFAF7812),
              padding: EdgeInsets.zero,
            ),
            onPressed: _addTask,
            child: const Icon(Icons.add, color: Colors.white, size: 26),
          ),
        ),
      ],
    );
  }

  Widget _priorityButton(Priority p, IconData icon, String label) {
    final selected = _selectedPriority == p;

    return GestureDetector(
      onTap: () => setState(() => _selectedPriority = p),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: selected ? _priorityColor(p) : Colors.white12,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: selected ? Colors.black : _priorityColor(p),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
