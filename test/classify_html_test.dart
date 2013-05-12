library classifyCssTests;

import 'package:classify_html/classify_html.dart';
import 'package:unittest/unittest.dart';

void main() {
  group('Classifies as type', () {
    validate('when core type or void', 
    	'<h1>Hello World</h1>', 
    	'&lt;<span class="t">h1</span>&gt;Hello World&lt;/<span class="t">h1</span>&gt;');
	});
}

validate(String description, String input, String expected, 
         {bool verbose: false}) {
	test(description, () {
		var actual = classifyHtml(input);
		var passed = (actual == expected);
		if (!passed) {
		  print('FAIL: $description');
      print('  expect: $expected');
      print('  actual: $actual');
      print('');
		}
		expect(passed, isTrue, verbose: verbose);
	});
}