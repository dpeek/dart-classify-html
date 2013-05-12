classify_html
=============

An HTML classifier. Parses a string of HTML5 and wraps each token (element, 
attribute, string, etc) with a `span` and a defined set of CSS classes. Used to 
add syntax coloring to documentation and code examples.

Supports extendible mixed mode highlighing of other inline syntax (ie. CSS, 
JavaScript or Dart).

Installation
------------

Add this to your `pubspec.yaml` (or create it):
```yaml
dependencies:
  classify_html: any
```
Then run the [Pub Package Manager][pub] (comes with the Dart SDK):

    pub install

Usage
-----

```dart
import "package:classify_html/classify_html.dart" show classifyHtml;

main() {
  print(classifyHtml("<span class='foo'>value</span>"));
}
```

[dartdoc]: https://github.com/d2m/dartdoc
[pub]: http://www.dartlang.org/docs/pub-package-manager/
