
import 'package:eventhandler/eventhandler.dart';

class ShoppingModeToggleEvent extends EventBase {
  final bool shoppingMode;
  ShoppingModeToggleEvent(this.shoppingMode);
}
