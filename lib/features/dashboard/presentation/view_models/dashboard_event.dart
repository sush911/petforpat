// features/dashboard/presentation/view_models/dashboard_event.dart

abstract class DashboardEvent {}

class LoadPetsEvent extends DashboardEvent {
  final String? search;
  final String? category;
  final bool forceRefresh;

  LoadPetsEvent({
    this.search,
    this.category,
    this.forceRefresh = false,
  });
}
