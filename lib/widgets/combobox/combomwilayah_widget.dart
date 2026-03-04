import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/repositories/combobox/combomwilayah_repository.dart';

// Revisi fungsi buildFieldComboMWilayah dengan desain custom
Widget buildFieldComboMWilayah({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMWilayahModel>>? comboKey,
	ComboMWilayahModel? initItem,
	Function(ComboMWilayahModel?)? onChangedCallback,
	required Function(ComboMWilayahModel?) onSaveCallback,
	Function(ComboMWilayahModel?)? validatorCallback
}) {
	return Column(
		crossAxisAlignment: CrossAxisAlignment.start,
		children: [
			// Label di atas field
			Text(
				labelText,
				style: const TextStyle(
					fontSize: 16,
					fontWeight: FontWeight.w500,
					color: Colors.black87,
				),
			),
			const SizedBox(height: 8),

			// DropdownSearch dengan custom decoration
			DropdownSearch<ComboMWilayahModel>(
				key: comboKey,
				selectedItem: initItem,
				decoratorProps: DropDownDecoratorProps(
					decoration: InputDecoration(
						hintText: '-- Pilih Wilayah --',
						hintStyle: const TextStyle(
							color: Colors.grey,
							fontSize: 14,
						),
						// Custom border dengan warna hijau
						border: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(
								color: Color(0xFF91C050),
								width: 1.5,
							),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(
								color: Color(0xFF91C050),
								width: 1.5,
							),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(
								color: Color(0xFF91C050),
								width: 2.0,
							),
						),
						errorBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(
								color: Colors.red,
								width: 1.5,
							),
						),
						focusedErrorBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(
								color: Colors.red,
								width: 2.0,
							),
						),
						contentPadding: const EdgeInsets.symmetric(
							horizontal: 16,
							vertical: 12,
						),
						// Hilangkan label text karena sudah ada di atas
						labelText: null,
					),
				),
				items: (filter, infiniteScrollProps) async {
					return ComboMWilayahRepository().getComboMWilayah();
				},
				suffixProps: const DropdownSuffixProps(
					clearButtonProps: ClearButtonProps(isVisible: true),
					dropdownButtonProps: DropdownButtonProps(
						iconClosed: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
						iconOpened: Icon(Icons.keyboard_arrow_up, color: Color(0xFF91C050)),
					),
				),
				popupProps: PopupProps.modalBottomSheet(
					disableFilter: false,
					showSelectedItems: true,
					showSearchBox: false,
					itemBuilder: itemBuilderComboMWilayah,
					// Custom modal design
					modalBottomSheetProps: const ModalBottomSheetProps(
						shape: RoundedRectangleBorder(
							borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
						),
					),
					containerBuilder: (context, popupWidget) {
						return Container(
							padding: const EdgeInsets.all(16),
							child: Column(
								mainAxisSize: MainAxisSize.min,
								children: [
									// Header modal
									Container(
										width: 50,
										height: 4,
										decoration: BoxDecoration(
											color: Colors.grey[300],
											borderRadius: BorderRadius.circular(2),
										),
									),
									const SizedBox(height: 16),
									Text(
										'Pilih $labelText',
										style: const TextStyle(
											fontSize: 18,
											fontWeight: FontWeight.bold,
										),
									),
									const SizedBox(height: 16),
									Flexible(child: popupWidget),
								],
							),
						);
					},
				),
				compareFn: (item, sItem) => item.mwilayahId == sItem.mwilayahId,
				itemAsString: (item) {
					return item.wilayahNama;
				},
				onChanged: (value) {
					if (onChangedCallback != null) {
						onChangedCallback(value);
					}
				},
				onSaved: (value) {
					onSaveCallback(value);
				},
				validator: (value) {
					if (validatorCallback != null) {
						validatorCallback(value);
						if (value == null) {
							return "Field $labelText tidak boleh kosong";
						}
					}
					return null;
				},
			),
		],
	);
}

// Revisi item builder dengan design yang lebih menarik
Widget itemBuilderComboMWilayah(
		BuildContext context, ComboMWilayahModel item, bool isSelected, bool isDisabled) {
	return Container(
		margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
		decoration: BoxDecoration(
			border: Border.all(
				color: isSelected ? const Color(0xFF91C050) : Colors.grey[300]!,
				width: isSelected ? 2 : 1,
			),
			borderRadius: BorderRadius.circular(8),
			color: isSelected ? const Color(0xFF91C050).withOpacity(0.1) : Colors.white,
		),
		child: ListTile(
			selected: isSelected,
			title: Text(
				item.wilayahNama,
				style: TextStyle(
					color: isSelected ? const Color(0xFF91C050) : Colors.black87,
					fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
				),
			),
			trailing: isSelected
					? const Icon(
				Icons.check_circle,
				color: Color(0xFF91C050),
				size: 20,
			)
					: null,
		),
	);
}
