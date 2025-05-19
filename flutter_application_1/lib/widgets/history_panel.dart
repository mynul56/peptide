import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPanel extends StatefulWidget {
  const HistoryPanel({Key? key}) : super(key: key);

  @override
  State<HistoryPanel> createState() => _HistoryPanelState();
}

class _HistoryPanelState extends State<HistoryPanel> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('calc_history') ?? [];
    setState(() {
      history = saved
          .map((e) => Map<String, dynamic>.from(
              Map<String, dynamic>.from(Uri.splitQueryString(e))))
          .toList()
          .reversed
          .toList();
    });
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('calc_history');
    setState(() {
      history.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("History cleared")),
    );
  }

  void _copyResult(String result) {
    Clipboard.setData(ClipboardData(text: result));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Result copied to clipboard")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.35,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(theme.brightness == Brightness.dark ? 0.3 : 0.1),
              blurRadius: 12,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    fontFamily: "Geist",
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_forever),
                  tooltip: 'Clear history',
                  onPressed: history.isEmpty ? null : _clearHistory,
                  color: theme.colorScheme.error,
                ),
              ],
            ),
            const Divider(height: 18),
            Expanded(
              child: history.isEmpty
                  ? Center(
                      child: Text(
                        "No calculations yet.",
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    )
                  : ListView.separated(
                      controller: controller,
                      itemCount: history.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final entry = history[i];
                        return ListTile(
                          title: Text(
                            entry['input'] ?? '',
                            style: TextStyle(
                              fontFamily: "Geist",
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            entry['result'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.secondary,
                              fontFamily: "Geist",
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy),
                            tooltip: 'Copy result',
                            onPressed: () => _copyResult(entry['result'] ?? ''),
                          ),
                          onTap: () {
                            Navigator.of(context).pop(entry);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
