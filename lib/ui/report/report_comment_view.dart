import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:podd_app/l10n/app_localizations.dart';
import 'package:podd_app/models/entities/comment.dart';
import 'package:podd_app/ui/home/incidents_theme.dart';
import 'package:podd_app/ui/report/report_comment_view_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

final _commentTimestamp = DateFormat('dd/MM/yyyy HH:mm');

class ReportCommentView extends StatelessWidget {
  final int threadId;

  const ReportCommentView(this.threadId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReportCommentViewModel>.reactive(
      viewModelBuilder: () => ReportCommentViewModel(threadId),
      builder: (context, viewModel, child) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await viewModel.fetchComments();
                },
                child: _CommentList(),
              ),
            ),
            _CommentComposer(),
          ],
        ),
      ),
    );
  }
}

class _CommentList extends StackedHookView<ReportCommentViewModel> {
  @override
  Widget builder(BuildContext context, ReportCommentViewModel viewModel) {
    final comments = viewModel.comments;
    if (comments.isEmpty) {
      return _CommentEmptyState();
    }
    return ScrollablePositionedList.separated(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      initialScrollIndex: comments.length - 1,
      itemScrollController: viewModel.scrollController,
      itemCount: comments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return _CommentCard(
          comment: comments[index],
          resolveImagePath: viewModel.resolveImagePath,
        );
      },
    );
  }
}

class _CommentCard extends StatelessWidget {
  final Comment comment;
  final dynamic Function(String) resolveImagePath;

  const _CommentCard({
    required this.comment,
    required this.resolveImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final attachments = comment.attachments;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: incidentsHair),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(
            avatarUrl: comment.user.avatarUrl,
            name: comment.user.username,
            resolveImagePath: resolveImagePath,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.user.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: incidentsFontFamily,
                    fontFamilyFallback: incidentsFontFamilyFallback,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: incidentsInk,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  _commentTimestamp.format(comment.createdAt.toLocal()),
                  style: const TextStyle(
                    fontFamily: incidentsFontFamily,
                    fontFamilyFallback: incidentsFontFamilyFallback,
                    fontSize: 10,
                    color: incidentsMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  comment.body,
                  style: const TextStyle(
                    fontFamily: incidentsFontFamily,
                    fontFamilyFallback: incidentsFontFamilyFallback,
                    fontSize: 13,
                    height: 1.5,
                    color: incidentsBody,
                  ),
                ),
                if (attachments.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 1,
                    ),
                    itemCount: attachments.length,
                    itemBuilder: (context, index) {
                      final attach = attachments[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: resolveImagePath(
                              attach.thumbnailPath ?? attach.filePath),
                          placeholder: (context, url) =>
                              Container(color: incidentsHair),
                          errorWidget: (context, url, error) => Container(
                            color: incidentsHair,
                            child: const Icon(Icons.broken_image,
                                color: incidentsMuted),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final dynamic Function(String) resolveImagePath;

  const _Avatar({
    required this.avatarUrl,
    required this.name,
    required this.resolveImagePath,
  });

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: 36,
          height: 36,
          child: CachedNetworkImage(
            imageUrl: resolveImagePath(avatarUrl!),
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: incidentsHair),
            errorWidget: (context, url, error) => _initialFallback(),
          ),
        ),
      );
    }
    return _initialFallback();
  }

  Widget _initialFallback() {
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: incidentsTeal.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          fontFamily: incidentsFontFamily,
          fontFamilyFallback: incidentsFontFamilyFallback,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: incidentsTeal,
        ),
      ),
    );
  }
}

class _CommentEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
      children: [
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: incidentsTeal.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 32,
              color: incidentsTeal,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          localize.noCommentsTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: incidentsFontFamily,
            fontFamilyFallback: incidentsFontFamilyFallback,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: incidentsInk,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          localize.noCommentsHelper,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: incidentsFontFamily,
            fontFamilyFallback: incidentsFontFamilyFallback,
            fontSize: 12.5,
            height: 1.5,
            color: incidentsMuted,
          ),
        ),
      ],
    );
  }
}

class _CommentComposer extends StackedHookView<ReportCommentViewModel> {
  @override
  Widget builder(BuildContext context, ReportCommentViewModel viewModel) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    final isFocused = useState(false);
    final hasText = useState(controller.text.trim().isNotEmpty);

    useEffect(() {
      void onFocus() => isFocused.value = focusNode.hasFocus;
      focusNode.addListener(onFocus);
      return () => focusNode.removeListener(onFocus);
    }, [focusNode]);

    useEffect(() {
      void onChange() {
        hasText.value = controller.text.trim().isNotEmpty;
      }

      controller.addListener(onChange);
      return () => controller.removeListener(onChange);
    }, [controller]);

    // Mirror controller text back into the view-model, and clear on submit.
    useEffect(() {
      if (viewModel.body == null && controller.text.isNotEmpty) {
        controller.clear();
      }
      return null;
    });

    final localize = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        10,
        12,
        10 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: incidentsHair)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _AttachButton(viewModel: viewModel),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viewModel.images.isNotEmpty) ...[
                  _PendingImagesGrid(images: viewModel.images),
                  const SizedBox(height: 8),
                ],
                Container(
                  constraints: const BoxConstraints(minHeight: 44),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: incidentsSand,
                    border: Border.all(
                      color: isFocused.value ? incidentsTeal : incidentsHair,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: viewModel.setBody,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: 4,
                    style: const TextStyle(
                      fontFamily: incidentsFontFamily,
                      fontFamilyFallback: incidentsFontFamilyFallback,
                      fontSize: 14,
                      color: incidentsInk,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                      hintText: localize.commentPlaceholder,
                      hintStyle: const TextStyle(
                        fontFamily: incidentsFontFamily,
                        fontFamilyFallback: incidentsFontFamilyFallback,
                        fontSize: 14,
                        color: incidentsMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _SendButton(
            enabled: hasText.value && !viewModel.isBusy,
            busy: viewModel.isBusy,
            onPressed: () async {
              await viewModel.saveComment();
              controller.clear();
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
        ],
      ),
    );
  }
}

class _AttachButton extends StatelessWidget {
  final ReportCommentViewModel viewModel;

  const _AttachButton({required this.viewModel});

  Future<void> _showAddImageModal(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Pick from Gallery'),
                onTap: () async {
                  final image = await _pickImage(ImageSource.gallery);
                  if (image != null) viewModel.addImage(image);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take a Photo'),
                onTap: () async {
                  final image = await _pickImage(ImageSource.camera);
                  if (image != null) viewModel.addImage(image);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<XFile?> _pickImage(ImageSource source) async {
    try {
      return await ImagePicker().pickImage(source: source);
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Material(
        color: incidentsTeal.withValues(alpha: 0.10),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => _showAddImageModal(context),
          child: const Icon(
            Icons.camera_alt_outlined,
            size: 22,
            color: incidentsTeal,
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool enabled;
  final bool busy;
  final VoidCallback onPressed;

  const _SendButton({
    required this.enabled,
    required this.busy,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bg = enabled ? incidentsTeal : incidentsHair;
    final fg = enabled ? Colors.white : incidentsMuted;
    return SizedBox(
      width: 44,
      height: 44,
      child: Material(
        color: bg,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? onPressed : null,
          child: busy
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(
                  Icons.send_rounded,
                  size: 20,
                  color: fg,
                ),
        ),
      ),
    );
  }
}

class _PendingImagesGrid extends StatelessWidget {
  final List images;

  const _PendingImagesGrid({required this.images});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(images[index], fit: BoxFit.cover),
        );
      },
    );
  }
}
