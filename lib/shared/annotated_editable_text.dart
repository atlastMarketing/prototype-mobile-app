// import 'package:flutter/widgets.dart';

// import 'package:atlast_mobile_app/configs/theme.dart';

// class AnnotatedEditableText extends EditableText {
//   final List<Annotation> annotations;
//   final int vSize;

//   AnnotatedEditableText({
//     Key? key,
//     required FocusNode focusNode,
//     required TextEditingController controller,
//     TextStyle style = AppText.blackText,
//     ValueChanged<String>? onChanged,
//     ValueChanged<String>? onSubmitted,
//     ValueChanged<PointerDownEvent>? onTapOutside,
//     Color cursorColor = AppColors.black,
//     Color? selectionColor,
//     TextSelectionControls? selectionControls,
//     required this.annotations,
//     this.vSize = 6,
//   }) : super(
//           key: key,
//           focusNode: focusNode,
//           controller: controller,
//           cursorColor: cursorColor,
//           style: style,
//           keyboardType: TextInputType.text,
//           autocorrect: true,
//           // autofocus: true,
//           selectionColor: selectionColor,
//           selectionControls: selectionControls,
//           onTapOutside: onTapOutside,
//           onSubmitted: onSubmitted,
//           backgroundCursorColor: AppColors.primary,
//           minLines: vSize,
//           maxLines: vSize,
//           // TODO: selection
//           // TODO: focus
//           enableInteractiveSelection: true,
//         );

//   @override
//   AnnotatedEditableTextState createState() => AnnotatedEditableTextState();
// }

// class AnnotatedEditableTextState extends EditableTextState {
//   @override
//   AnnotatedEditableText get widget => super.widget as AnnotatedEditableText;

//   List<Annotation> getRanges() {
//     if (widget.annotations.isEmpty) return [];
//     var source = widget.annotations;
//     source.sort();

//     List<Annotation> result = [];

//     Annotation? prev;
//     for (var item in source) {
//       if (prev == null) {
//         // First item, check if we need one before it.
//         if (item.range.start > 0) {
//           result.add(Annotation(
//             range: TextRange(start: 0, end: item.range.start),
//           ));
//         }
//         result.add(item);
//         prev = item;
//         continue;
//       } else {
//         // Consequent item, check if there is a gap between.
//         if (prev.range.end > item.range.start) {
//           // Invalid ranges
//           throw StateError('Invalid (intersecting) ranges for annotated field');
//         } else if (prev.range.end < item.range.start) {
//           result.add(Annotation(
//             range: TextRange(start: prev.range.end, end: item.range.start),
//           ));
//         }
//         // Also add current annotation
//         result.add(item);
//         prev = item;
//       }
//     }
//     // Also check for trailing range
//     final String text = textEditingValue.text;
//     if (result.last.range.end < text.length) {
//       result.add(Annotation(
//         range: TextRange(start: result.last.range.end, end: text.length),
//       ));
//     }
//     return result;
//   }

//   @override
//   TextSpan buildTextSpan() {
//     final String text = textEditingValue.text;
//     int textLength = text.length;
//     if (widget.annotations.isNotEmpty && textLength > 0) {
//       var items = getRanges();
//       var children = <TextSpan>[];
//       for (var item in items) {
//         if (item.range.end < textLength) {
//           children.add(
//             TextSpan(style: item.style, text: item.range.textInside(text)),
//           );
//         } else if (item.range.start <= textLength) {
//           children.add(
//             TextSpan(
//                 style: item.style,
//                 text: TextRange(start: item.range.start, end: text.length)
//                     .textInside(text)),
//           );
//         }
//       }
//       return TextSpan(style: widget.style, children: children);
//     }

//     return TextSpan(style: widget.style, text: text);
//   }
// }
