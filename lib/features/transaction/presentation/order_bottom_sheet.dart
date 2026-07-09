import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/shared_widgets/custom_button.dart';

class OrderBottomSheet extends StatefulWidget {
  final String movieId;
  final String movieTitle;
  final String cinemaId;
  final String cinemaName;
  final double pricePerTicket;

  const OrderBottomSheet({
    super.key,
    required this.movieId,
    required this.movieTitle,
    required this.cinemaId,
    required this.cinemaName,
    this.pricePerTicket = 50000,
  });

  @override
  State<OrderBottomSheet> createState() => _OrderBottomSheetState();
}

class _OrderBottomSheetState extends State<OrderBottomSheet> {
  int _quantity = 1;
  String _selectedDate = '12'; // Default: HARI INI (12)
  String _selectedTime = '13:15'; // Default: 13:15 (REGULAR 2D)
  String _selectedClass = 'REGULAR 2D'; // Default class type

  final List<Map<String, String>> _dates = [
    {'day': 'HARI INI', 'num': '12'},
    {'day': 'BESOK', 'num': '13'},
    {'day': 'KAM', 'num': '14'},
    {'day': 'JUM', 'num': '15'},
    {'day': 'SAB', 'num': '16'},
  ];

  final Map<String, List<String>> _timeSlots = {
    'REGULAR 2D': ['10:30', '13:15', '16:00', '18:45', '21:30'],
    'IMAX 2D': ['14:20', '19:00'],
  };

  void _proceedToSeatSelection() {
    Navigator.pop(context); // Close bottom sheet
    
    // Navigate to Seat Selection Screen carrying transaction context
    context.push(
      '/seat-selection'
      '?movieId=${widget.movieId}'
      '&movieTitle=${Uri.encodeComponent(widget.movieTitle)}'
      '&cinemaId=${widget.cinemaId}'
      '&cinemaName=${Uri.encodeComponent(widget.cinemaName)}'
      '&date=$_selectedDate'
      '&time=$_selectedTime'
      '&classType=$_selectedClass'
      '&qty=$_quantity'
      '&price=${widget.pricePerTicket}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.pricePerTicket * _quantity;
    
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Header info
          const Text(
            'Beli Tiket',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Movie Details summary
          Text(
            widget.movieTitle,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            widget.cinemaName,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          
          // Date Selector
          const Text(
            'Pilih Tanggal',
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _dates.length,
              itemBuilder: (context, index) {
                final date = _dates[index];
                final isSelected = _selectedDate == date['num'];
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date['num']!;
                    });
                  },
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          date['day']!,
                          style: TextStyle(
                            color: isSelected ? AppColors.background : AppColors.textSecondary,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date['num']!,
                          style: TextStyle(
                            color: isSelected ? AppColors.background : AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          
          // Time Slots Selector
          const Text(
            'Pilih Jam Tayang',
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          
          // Map each Studio Type
          ..._timeSlots.entries.map((entry) {
            final classType = entry.key;
            final slots = entry.value;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Text(
                    classType,
                    style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: slots.map((slot) {
                    final isSelected = _selectedTime == slot && _selectedClass == classType;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTime = slot;
                          _selectedClass = classType;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                        ),
                        child: Text(
                          slot,
                          style: TextStyle(
                            color: isSelected ? AppColors.background : AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }),
          const SizedBox(height: 24),
          
          // Stepper +/- for Ticket Qty
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Jumlah Tiket',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.background,
                      side: const BorderSide(color: AppColors.border),
                    ),
                    onPressed: _quantity <= 1
                        ? null
                        : () => setState(() => _quantity--),
                    icon: const Icon(Icons.remove, color: AppColors.textPrimary),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '$_quantity',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.background,
                      side: const BorderSide(color: AppColors.border),
                    ),
                    onPressed: _quantity >= 10
                        ? null
                        : () => setState(() => _quantity++),
                    icon: const Icon(Icons.add, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Total and Proceed Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Pembayaran', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              CustomButton(
                width: 140,
                text: 'Pilih Kursi',
                onPressed: _proceedToSeatSelection,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
