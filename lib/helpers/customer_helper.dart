import '../models/shipment_day_enum.dart';

class CustomerHelper {

  String returnShipmentDay(shipmentDay){
    return (shipmentDay != null ? Days.values[shipmentDay].toString().substring(Days.values[shipmentDay].toString().indexOf('.')+1) : 'Sin Asignar');
  }
  
}