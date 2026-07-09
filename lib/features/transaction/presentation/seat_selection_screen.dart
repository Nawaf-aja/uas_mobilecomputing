import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/shared_widgets/custom_button.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String movieId;
  final String movieTitle;
  final String cinemaId;
  final String cinemaName;
  final String date;
  final String time;
  final String classType;
  final int qty;
  final double price;

  const SeatSelectionScreen({
    super.key,
    required this.movieId,
    required this.movieTitle,
    required this.cinemaId,
    required this.cinemaName,
    required this.date,
    required this.time,
    required this.classType,
    required this.qty,
    required this.price,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final List<String> _selectedSeats = [];
  final List<String> _soldSeats = ['B4', 'B5', 'C6', 'C7', 'D2', 'D3', 'F5', 'F6', 'G8', 'G9'];
  final List<String> _recommendedSeats = ['E5', 'E6', 'D5', 'D6', 'F5', 'F6'];

  final List<String> _rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  final int _cols = 10;

  void _onSeatTap(String seatId) {
    if (_soldSeats.contains(seatId)) return; // Already sold

    setState(() {
      if (_selectedSeats.contains(seatId)) {
        _selectedSeats.remove(seatId);
      } else {
        // Limit selection to the quantity chosen in bottom sheet
        if (_selectedSeats.length < widget.qty) {
          _selectedSeats.add(seatId);
        } else {
          // Replace first selected seat
          _selectedSeats.removeAt(0);
          _selectedSeats.add(seatId);
        }
      }
    });
  }

  void _confirmSelection() {
    if (_selectedSeats.length < widget.qty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Silakan pilih ${widget.qty} kursi terlebih dahulu.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Success snackbar and route back to home profile / ticket history
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pemesanan ${_selectedSeats.join(", ")} Berhasil!'),
        backgroundColor: AppColors.success,
      ),
    );
    
    // Go back to main tab bar home
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.price * widget.qty;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pilih Kursi'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Movie & Cinema context header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      widget.movieTitle,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.cinemaName} • Hari Ini, ${widget.time} (${widget.classType})',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: AppColors.border),
            const SizedBox(height: 16),

            // Cinema Screen Indicator
            Column(
              children: [
                // Curved Screen Line
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'L A Y A R',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Grid of Seats
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: _rows.map((row) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Row label left
                              SizedBox(
                                width: 24,
                                child: Text(
                                  row,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              
                              // Seats row loop
                              ...List.generate(_cols, (colIndex) {
                                final seatNum = colIndex + 1;
                                final seatId = '$row$seatNum';
                                final isSelected = _selectedSeats.contains(seatId);
                                final isSold = _soldSeats.contains(seatId);
                                final isRecommended = _recommendedSeats.contains(seatId);

                                // Render gap for corridors (between 2-3, and 8-9)
                                final showLeftGap = colIndex == 2 || colIndex == 8;

                                return Row(
                                  children: [
                                    if (showLeftGap) const SizedBox(width: 16),
                                    GestureDetector(
                                      onTap: () => _onSeatTap(seatId),
                                      child: Container(
                                        width: 26,
                                        height: 26,
                                        margin: const EdgeInsets.symmetric(horizontal: 3),
                                        decoration: BoxDecoration(
                                          color: isSold
                                              ? AppColors.border
                                              : isSelected
                                                  ? AppColors.primary
                                                  : isRecommended
                                                      ? AppColors.primary.withValues(alpha: 0.15)
                                                      : AppColors.cardBackground,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: isSold
                                                ? AppColors.border
                                                : isSelected
                                                    ? AppColors.primary
                                                    : isRecommended
                                                        ? AppColors.primary.withValues(alpha: 0.8)
                                                        : AppColors.border,
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            seatNum.toString(),
                                            style: TextStyle(
                                              color: isSelected
                                                  ? AppColors.background
                                                  : isSold
                                                      ? AppColors.textSecondary.withValues(alpha: 0.5)
                                                      : isRecommended
                                                          ? AppColors.primary
                                                          : AppColors.textPrimary,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              
                              // Row label right
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 24,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    row,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),

            // Legend indicators
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _buildLegendItem('Tersedia', AppColors.cardBackground, AppColors.border),
                  _buildLegendItem('Dipilih', AppColors.primary, AppColors.primary),
                  _buildLegendItem('Terisi', AppColors.border, AppColors.border),
                  _buildLegendItem('Rekomendasi', AppColors.primary.withValues(alpha: 0.15), AppColors.primary),
                ],
              ),
            ),

            // Bottom Actions Bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kursi Terpilih',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedSeats.isNotEmpty ? _selectedSeats.join(', ') : '-',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total Pembayaran (${_selectedSeats.length}/${widget.qty})',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${totalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Konfirmasi Pemesanan',
                    onPressed: _selectedSeats.length == widget.qty ? _confirmSelection : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color boxColor, Color borderColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor, width: 1),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}
