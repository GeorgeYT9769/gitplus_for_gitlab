void main() {
  String data = '<text aria-hidden="true" x="215" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)" textLength="310">fdroid</text>';
  var fixed = data.replaceAllMapped(
      RegExp(r'<text([^>]*)transform="scale\(\.?1\)"([^>]*)>(.*?)</text>'), 
      (m) => '<g transform="scale(.1)"><text${m[1]}${m[2]}>${m[3]}</text></g>'
  );
  print(fixed);
}
