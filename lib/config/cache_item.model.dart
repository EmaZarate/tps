import 'cache.config.dart';

class CacheListItem<T>{
  final int millisecondsSinceEpochWhenCached;
  final List<T> listCached; 

  CacheListItem({this.millisecondsSinceEpochWhenCached, this.listCached});

  canReturnCached() {
    if(listCached.isEmpty){
      return false;
    }
    if((DateTime.now().millisecondsSinceEpoch - millisecondsSinceEpochWhenCached) > CacheConfig.EXPIRATION_TIME){
      return false;
    }

    return true;
  }

  CacheListItem copyWith({List<T> listCached, int millisecondsSinceEpochWhenCached}){
    return CacheListItem<T>(
      listCached: listCached ?? this.listCached,
      millisecondsSinceEpochWhenCached: millisecondsSinceEpochWhenCached ?? this.millisecondsSinceEpochWhenCached
    );
  }
}