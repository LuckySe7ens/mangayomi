import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga_reader.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/views/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/views/manga/download/download_page_widget.dart';

class ChapterListTileWidget extends ConsumerWidget {
  final List<ModelChapters> chapters;
  final ModelManga modelManga;
  final bool reverse;
  final int reverseIndex;
  final int finalIndex;
  final bool isLongPressed;
  const ChapterListTileWidget(
      {super.key,
      required this.chapters,
      required this.modelManga,
      required this.reverse,
      required this.reverseIndex,
      required this.finalIndex,
      required this.isLongPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = reverse ? reverseIndex : finalIndex;
    final chapterIndex = ref.watch(chapterIndexStateProvider);
    return Container(
      color:
          chapterIndex == idx ? generalColor(context).withOpacity(0.4) : null,
      child: ListTile(
        textColor: chapters[finalIndex].isRead
            ? isLight(context)
                ? Colors.black.withOpacity(0.4)
                : Colors.white.withOpacity(0.3)
            : null,
        selectedColor: chapters[finalIndex].isRead
            ? Colors.white.withOpacity(0.3)
            : Colors.white,
        onLongPress: () {
          if (!isLongPressed) {
            ref.read(chapterIndexStateProvider.notifier).update(idx);
            ref
                .read(chapterModelStateProvider.notifier)
                .update(chapters[finalIndex]);
          } else {
            ref.read(chapterIndexStateProvider.notifier).update(-1);
          }
          ref.read(isLongPressedStateProvider.notifier).update(!isLongPressed);
        },
        onTap: () {
          if (isLongPressed) {
            ref.read(chapterIndexStateProvider.notifier).update(idx);
            ref
                .read(chapterModelStateProvider.notifier)
                .update(chapters[finalIndex]);
            if (chapterIndex == idx) {
              ref.read(chapterIndexStateProvider.notifier).update(-1);
              ref
                  .read(isLongPressedStateProvider.notifier)
                  .update(!isLongPressed);
            }
          } else {
            pushMangaReaderView(
                context: context,
                modelManga: modelManga,
                index: reverse ? reverseIndex : finalIndex);
          }
        },
        title: Row(
          children: [
            chapters[finalIndex].isBookmarked
                ? Icon(
                    Icons.bookmark,
                    size: 15,
                    color: generalColor(context),
                  )
                : Container(),
            Text(
              chapters[finalIndex].name!,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
        subtitle: Text(
          chapters[finalIndex].dateUpload!,
          style: const TextStyle(fontSize: 11),
        ),
        trailing: ref.watch(ChapterPageDownloadsProvider(
            index: reverse ? reverseIndex : finalIndex,
            modelManga: modelManga)),
      ),
    );
  }
}