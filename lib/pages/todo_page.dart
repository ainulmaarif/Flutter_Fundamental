import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/todo_provider.dart';

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo Riverpod - Ainul (23520010)'),
      ),
      body: todos.isEmpty
          ? const Center(
              child: Text(
                'Belum ada tugas',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];

                return ListTile(
                  leading: Checkbox(
                    value: todo.done,
                    onChanged: (_) =>
                        ref.read(todoListProvider.notifier).toggle(index),
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration:
                          todo.done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  // Tombol aksi: Edit dan Hapus
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol Edit
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        tooltip: 'Edit tugas',
                        onPressed: () =>
                            _showEditDialog(context, ref, index, todo.title),
                      ),
                      // Tombol Hapus
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        tooltip: 'Hapus tugas',
                        onPressed: () =>
                            ref.read(todoListProvider.notifier).remove(index),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Dialog untuk mengedit tugas yang sudah ada
  void _showEditDialog(
      BuildContext context, WidgetRef ref, int index, String currentTitle) {
    final controller = TextEditingController(text: currentTitle);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Tugas'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nama tugas baru',
          ),
          onSubmitted: (_) {
            if (controller.text.trim().isNotEmpty) {
              ref
                  .read(todoListProvider.notifier)
                  .edit(index, controller.text.trim());
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(todoListProvider.notifier)
                    .edit(index, controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // Dialog untuk menambah tugas baru
  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tugas baru'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Ketik nama tugas...',
          ),
          onSubmitted: (_) {
            if (controller.text.trim().isNotEmpty) {
              ref.read(todoListProvider.notifier).add(controller.text.trim());
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(todoListProvider.notifier).add(controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }
}