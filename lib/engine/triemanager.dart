import 'package:hanzishu/trie/key_value_trie.dart';
//import 'package:hanzishu/trie/trie.dart';
import 'package:hanzishu/data/inputzilist.dart';

class TrieManager {
  // Use a key-value trie to associate each word with a value.
  final keyValueTrie = KeyValueTrie<String>(); // Values of type String.

  TrieManager() {
    init();
  }

  List<String> find(String code) {
    return keyValueTrie.find(code);
  }

  void init() {
    /*
    final trie = Trie();

    // Insert a word into trie with trie.insert().
    trie.insert('crikey');
    trie.insert('crocodile');

    // You can use the list's forEach method for repeated insertion.
    final words = <String>['brekky', 'breakfast'];
    words.forEach(trie.insert);

    // Check for existence of words.
    print(trie.has('brekky')); // true
    print(trie.has('ghost')); // false

    // Find matching words by prefix.
    print(trie.find('br')); // ['breakfast', 'brekky']
    print(trie.find('cr')); // ['crocodile', 'crikey']
    print(trie.find('crikey')); // ['crikey']
    print(trie.find('ghost')); // []
    */

    for (var index = 0; index <= theInputZiList.length - 1; index++) {
      //keyValueTrie.insert('trophy', '🏆');
      //keyValueTrie.insert('train', '🚆');
      keyValueTrie.insert(
          theInputZiList[index].doubleByteCode, theInputZiList[index].zi);

      // When finding matching words by prefix, the associated value is returned.
      //print(keyValueTrie.find('tr')); // ['🚆', '🏆']
      //print(keyValueTrie.find('trophy')); // ['🏆']
      //print(keyValueTrie.find('trie')); // []
    }
  }
}