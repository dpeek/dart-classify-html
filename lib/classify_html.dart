// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library classify_html;

import 'package:html5lib/src/token.dart';
import 'package:html5lib/src/tokenizer.dart';

String classifyHtml(String src) {
  var out = new StringBuffer();
  var tokenizer = new HtmlTokenizer(src, encoding:'utf8', generateSpans:true, attributeSpans:true);
  var syntax = '';
  
  while (tokenizer.moveNext()) {
    var token = tokenizer.current;
    var classification = Classification.NONE;
    
    switch (token.kind)
    {
      case TokenKind.characters:
        var chars = token.span.text;
//        if (syntax == 'dart') {
//          chars = classifyDart(chars);
//        } else 
//        if (syntax == 'css') {
//          chars = classifyCss(chars);
//        } else {
          chars = _escapeHtml(chars);
//        }
        out.write(chars);
        syntax = '';
      continue;
      case TokenKind.comment:
        classification = Classification.COMMENT;
      break;
      case TokenKind.doctype:
        classification = Classification.COMMENT;
      break;
        
      case TokenKind.startTag:
        addTag(out, token);
        var tag = token as StartTagToken;
        if (tag.name == 'script') {
          tag.data.forEach((pair) {
            if (pair[0] == 'type' && pair[1] == 'application/dart') {
              syntax = 'dart';
            }
          });
        } else if (token.name == 'style') {
          syntax = 'css';
        }
      continue;
      
      case TokenKind.endTag:
        addTag(out, token);
      continue;
      
      case TokenKind.parseError:
        classification = Classification.ERROR;
      break;
      case TokenKind.spaceCharacters:
        classification = Classification.NONE;
      break;
    }
    var str = _escapeHtml(token.span.text);
    out.write('<span class="$classification">$str</span>');
  }
  
  return out.toString();
}

final _RE_ATTR = new RegExp(r'( +[\w\-]+)( *= *)?(".+?")?');

String addTag(StringBuffer buf, TagToken token) {
  var start = token.kind == TokenKind.endTag ? 2 : 1;
  var end = token.selfClosing ? 2 : 1;
  var text = token.span.text;
  
  // Add the start of the tag.
  buf.write(_escapeHtml(text.substring(0, start)));
  
  // Add the tag name.
  _addSpan(buf, Classification.TYPE_IDENTIFIER, token.name);
  
  // Add the tag attributes.
  var content = text.substring(start, text.length - end);
  _RE_ATTR.allMatches(content).forEach((match) {
    _addSpan(buf, Classification.KEYWORD, match[1]);
    if (match[2] != null) buf.write(match[2]);
    if (match[3] != null) {
      _addSpan(buf, Classification.STRING, match[3]);
    }
  });
  
  // Add the end of the tag.
  buf.write(_escapeHtml(text.substring(text.length - end, text.length)));
}

class Classification {
  static const NONE = "";
  static const ERROR = "e";
  static const COMMENT = "c";
  static const IDENTIFIER = "i";
  static const KEYWORD = "k";
  static const OPERATOR = "o";
  static const STRING = "s";
  static const NUMBER = "n";
  static const PUNCTUATION = "p";
  static const TYPE_IDENTIFIER = "t";
  static const SPECIAL_IDENTIFIER = "r";
  static const ARROW_OPERATOR = "a";
  static const STRING_INTERPOLATION = 'si';
}

String _addSpan(StringBuffer buffer, String cls, String text) {
  buffer.write('<span class="$cls">${_escapeHtml(text)}</span>');
}

/// Replaces `<`, `&`, and `>`, with their HTML entity equivalents.
String _escapeHtml(String html) {
  return html.replaceAll('&', '&amp;')
             .replaceAll('<', '&lt;')
             .replaceAll('>', '&gt;');
}
