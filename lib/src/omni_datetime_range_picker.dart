import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/button_row.dart';
import 'components/custom_tab_view.dart';
import 'components/range_tab_bar.dart';
import '../omni_datetime_picker.dart';

class OmniDateTimeRangePicker extends StatefulWidget {
  final Widget? title;
  final Widget? titleSeparator;
  final Widget? separator;
  final Widget? startLabelWidget;
  final Widget? endLabelWidget;

  final DateTime? startInitialDate;
  final DateTime? startFirstDate;
  final DateTime? startLastDate;
  final bool Function(DateTime)? startSelectableDayPredicate;

  final DateTime? endInitialDate;
  final DateTime? endFirstDate;
  final DateTime? endLastDate;
  final bool Function(DateTime)? endSelectableDayPredicate;

  final String? amText;
  final String? pmText;
  final bool? isShowSeconds;
  final bool? is24HourMode;
  final int? minutesInterval;
  final int? secondsInterval;
  final bool? isForce2Digits;
  final bool? looping;
  final Widget? selectionOverlay;

  final EdgeInsets? padding;
  final EdgeInsets? insetPadding;
  final BorderRadiusGeometry? borderRadius;
  final BoxConstraints? constraints;
  final OmniDateTimePickerType? type;

  final bool isForceEndDateAfterStartDate;
  final void Function()? onStartDateAfterEndDateError;
  final DefaultTab? defaultTab;

  final ButtonRowBuilder? actionsBuilder;

  final void Function(DateTime)? onStateTimeChanged;
  final void Function(DateTime)? onEndTimeChanged;

  final void Function()? onCancelPressed;
  final void Function(DateTime, DateTime)? onSavePressed;

  final ThemeData? theme;

  const OmniDateTimeRangePicker({
    super.key,
    this.title,
    this.titleSeparator,
    this.startLabelWidget,
    this.endLabelWidget,
    this.separator,
    this.startInitialDate,
    this.startFirstDate,
    this.startLastDate,
    this.startSelectableDayPredicate,
    this.endInitialDate,
    this.endFirstDate,
    this.endLastDate,
    this.endSelectableDayPredicate,
    this.amText,
    this.pmText,
    this.isShowSeconds,
    this.is24HourMode,
    this.minutesInterval,
    this.secondsInterval,
    this.isForce2Digits,
    this.looping,
    this.selectionOverlay,
    this.padding,
    this.insetPadding,
    this.borderRadius,
    this.constraints,
    this.type,
    bool? isForceEndDateAfterStartDate,
    this.onStartDateAfterEndDateError,
    this.defaultTab,
    this.actionsBuilder,
    this.onStateTimeChanged,
    this.onEndTimeChanged,
    this.onSavePressed,
    this.onCancelPressed,
    this.theme,
  }) : isForceEndDateAfterStartDate = isForceEndDateAfterStartDate ?? false;

  @override
  State<OmniDateTimeRangePicker> createState() => _OmniDateTimeRangePickerState();
}

class _OmniDateTimeRangePickerState extends State<OmniDateTimeRangePicker> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  DateTime? _selectedStartDateTime;
  DateTime? _selectedEndDateTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.defaultTab?.index ?? 0,
    );
    _selectedStartDateTime = widget.startInitialDate ?? DateTime.now();
    _selectedEndDateTime = widget.endInitialDate ?? DateTime.now();

    assert(
      !(widget.isForceEndDateAfterStartDate && (widget.startLastDate == null && widget.endLastDate != null)),
      'endLastDate cannot be set when startLastDate is null and forceEndDateAfterStartDate is true',
    );
    assert(
      !(widget.isForceEndDateAfterStartDate &&
          (widget.startLastDate != null &&
              widget.endLastDate != null &&
              (widget.startLastDate!.isAfter(widget.endLastDate!) ||
                  widget.startLastDate!.isAtSameMomentAs(widget.endLastDate!)))),
      'endLastDate cannot less than startLastDate when forceEndDateAfterStartDate is true',
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.theme ?? Theme.of(context),
      child: ConstrainedBox(
        constraints: widget.constraints ?? const BoxConstraints.tightFor(),
        child: Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title != null) widget.title!,
              if (widget.title != null && widget.titleSeparator != null) widget.titleSeparator!,
              RangeTabBar(
                tabController: _tabController,
                startWidget: widget.startLabelWidget,
                endWidget: widget.endLabelWidget,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: CustomTabView(
                    controller: _tabController,
                    children: [
                      // Start
                      OmniDateTimePicker(
                        key: const ValueKey('start'),
                        onDateTimeChanged: (dateTime) {
                          widget.onStateTimeChanged?.call(dateTime);
                          _selectedStartDateTime = dateTime;
                        },
                        initialDate: widget.startInitialDate,
                        firstDate: widget.startFirstDate,
                        lastDate: widget.startLastDate,
                        selectableDayPredicate: widget.startSelectableDayPredicate,
                        amText: widget.amText,
                        pmText: widget.pmText,
                        isShowSeconds: widget.isShowSeconds ?? false,
                        is24HourMode: widget.is24HourMode ?? false,
                        minutesInterval: widget.minutesInterval ?? 1,
                        secondsInterval: widget.secondsInterval ?? 1,
                        isForce2Digits: widget.isForce2Digits ?? true,
                        looping: widget.looping ?? true,
                        selectionOverlay: widget.selectionOverlay ?? const CupertinoPickerDefaultSelectionOverlay(),
                        separator: widget.separator,
                        type: widget.type ?? OmniDateTimePickerType.dateAndTime,
                      ),
                      // End
                      OmniDateTimePicker(
                        key: const ValueKey('end'),
                        onDateTimeChanged: (dateTime) {
                          widget.onEndTimeChanged?.call(dateTime);
                          _selectedEndDateTime = dateTime;
                        },
                        initialDate: widget.endInitialDate,
                        firstDate: widget.endFirstDate,
                        lastDate: widget.endLastDate,
                        selectableDayPredicate: widget.endSelectableDayPredicate,
                        amText: widget.amText,
                        pmText: widget.pmText,
                        isShowSeconds: widget.isShowSeconds ?? false,
                        is24HourMode: widget.is24HourMode ?? false,
                        minutesInterval: widget.minutesInterval ?? 1,
                        secondsInterval: widget.secondsInterval ?? 1,
                        isForce2Digits: widget.isForce2Digits ?? true,
                        looping: widget.looping ?? true,
                        selectionOverlay: widget.selectionOverlay ?? const CupertinoPickerDefaultSelectionOverlay(),
                        separator: widget.separator,
                        type: widget.type ?? OmniDateTimePickerType.dateAndTime,
                      ),
                    ],
                  ),
                ),
              ),
              ButtonRow(
                actionsBuilder: widget.actionsBuilder,
                onCancelPressed: () {
                  widget.onCancelPressed?.call();
                },
                onSavePressed: () {
                  if (widget.isForceEndDateAfterStartDate) {
                    if (_selectedEndDateTime!.isBefore(_selectedStartDateTime!)) {
                      if (widget.onStartDateAfterEndDateError != null) {
                        widget.onStartDateAfterEndDateError!();
                      }

                      return;
                    }
                  }

                  widget.onSavePressed?.call(_selectedStartDateTime!, _selectedEndDateTime!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
