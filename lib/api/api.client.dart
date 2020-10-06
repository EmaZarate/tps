import 'dart:convert';
import 'dart:async';

import 'package:andina_protos/models/auth.dart';
import 'package:andina_protos/models/branch.dart';
import 'package:andina_protos/models/category.dart';
import 'package:andina_protos/models/change_password.dart';
import 'package:andina_protos/models/customer.dart';
import 'package:andina_protos/models/order.dart';
import 'package:andina_protos/models/payment_option.dart';
import 'package:andina_protos/models/sale.dart';
import 'package:andina_protos/models/shipment_option.dart';

import 'package:andina_protos/models/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ApiClient {
  constructor(){}
  String graphQLUrl = DotEnv().env['graphQLUrl'];

  String customerUrl = DotEnv().env['customerUrl'];
      

  final http.Client httpClient;
  ApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<List<Sale>> getSales() async {
  const String getSales = """
  {
	sales{
    saleID
    name
    price
    image
    priceLists{
       price
       code
    }
    packings{
    	packingID
    	quantity
    	productID
    	saleID
    	packing:packing_Navigation{
    		packingID
            name
            hasStock
            priceLists{
              price
              priceList_Navigation{
              	code
              }
            }
            product:product_Navigation{
              	name
                image
                assetsImageName
            }
    	}
    }
  }
  } 
      """;
    final response = await makeCall(getSales);
    final List<Sale> sales = (response["sales"] as List)
        .map((p) => Sale.fromJson(p))
        .toList();

    return sales;
  }

  Future<List<ProductProd>> getProducts(List<int> categoriesFilter, String seachText, int page) async {
    final String getProducts = '''
       {
	products(idsCategory: $categoriesFilter, page: $page, pageSize: 5, productName: "$seachText"){
    productID
    image
    name
    sKU
    assetsImageName
    packing: packings{
      packingID
      name
      hasStock
      price
      quantity
      priceLists{
        price
      }
    }
    category{
      categoryID
      name
    }
    
  }
        }
      ''';
    final response = await makeCall(getProducts);
    final List<ProductProd> products = (response["products"] as List)
        .map((p) => ProductProd.fromJson(p))
        .toList();

    return products;
  }

  Future<List<Category>> getCategories() async {
    const String getCategories = '''
       {
          categories{
            categoryID
            name
          }
        }
      ''';
    final categoryResponse = await makeCall(getCategories);

    final List<Category> categoryList = (categoryResponse['categories'] as List)
        .map((p) => Category.fromJson(p))
        .toList();

    return categoryList;
  }

  Future<Auth> loginCustomer(String username, String password) async {
    final request = {"username": username, "password": password};

    String loginUrl = '$customerUrl/login';

    final loginResponse = await httpClient.post(loginUrl,
        body: json.encode(request),
        headers: {"content-type": "application/json"});
    final decodedResponse = json.decode(loginResponse.body);

    if (decodedResponse['isOk'] as bool) {
      final Auth auth = Auth.fromJson(decodedResponse["data"]);
      return auth;
    }

    throw Exception("Invalid username or password");
  }

  Future<Customer> getMe({String id}) async {
    final String getMeQuery = ''' 
    {
      customer(id: "$id"){
        id
        username
        email
        image
        shipmentDay
        minimumLimit
        businessName: bussinessName
        branches{
          branchID
          address
          city
          name
          province
          orders {
            orderID
            orderStateID
            percentPaymentOption
            percentShipmentOption
            total
            orderState {
              orderStateID
              name
            }
          }
        }
      }
    }
    ''';

    final getMeResponse = await makeCall(getMeQuery);
    final Customer customer = new Customer.fromJson(getMeResponse['customer']);
    return customer;
  }

  Future<List<ShipmentOption>> getShipmentOptions() async {
    const String getShipmentOptions = '''
     {
        shipmentOptions{
          name
          percent
          shipmentOptionID
        }
      }
  ''';
    final shipmentOptionsResponse = await makeCall(getShipmentOptions);

    final List<ShipmentOption> shipmentOptionsList =
        (shipmentOptionsResponse['shipmentOptions'] as List)
            .map((so) => ShipmentOption.fromJson(so))
            .toList();

    return shipmentOptionsList;
  }

  Future<List<PaymentOption>> getPaymentOptions() async {

    const String getPaymentOptions = '''
    {
        paymentOptions{
          name
          percent
          paymentOptionID
        }
        }
  ''';
    final paymentOptionsResponse = await makeCall(getPaymentOptions);

    final List<PaymentOption> paymentOptionsList =
        (paymentOptionsResponse['paymentOptions'] as List)
            .map((po) => PaymentOption.fromJson(po))
            .toList();

    return paymentOptionsList;
  }

  Future addBranch(String customerId, Branch branch) async {
    final String branchMutation = ''' 
      mutation {
        addBranch(id: "$customerId", branch: {
          name: "${branch.name}",
          address: "${branch.address}",
          city: "${branch.city}",
          province: "${branch.province}"
        }){
          id
        }
      }
    ''';

    await makeCall(branchMutation);
  }

  Future updateBranch(String customerId, Branch branch) async {
    final String branchMutation = ''' 
      mutation {
        updateBranch(branch: {
          branchID: ${branch.id},
          name: "${branch.name}",
          address: "${branch.address}",
          city: "${branch.city}",
          province: "${branch.province}",
          customerID: "$customerId"
        })
      }
    ''';
    await makeCall(branchMutation);
  }

  Future removeBranch(String customerId, int branchId) async {
    final String branchMutation = ''' 
      mutation {
        removeBranch(branch: {
          branchID: $branchId,
          customerID: "$customerId"
        })
      }
    ''';
    await makeCall(branchMutation);
  }

  Future<int> finishOrder(Order order, String customerId) async {
    final String addOrderMutation = r''' 
      mutation($order: OrderInput!) {
        addOrder(order: $order) {orderID}
      }
    ''';
    final Map<String, Map<dynamic, dynamic>> mutationVariable = {
      "order": {
        "shipmentOptionID": order.shipmentOption.id,
        "customerID": customerId,
        "paymentOptionID": order.paymentOption.id,
        "branchID": order.branch.id,
        "itemOrders": order.itemOrders.map((f) => f.toMap()).toList()
      }
    };

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? null;
    Map<String, dynamic> body = {
      "query": addOrderMutation,
      "variables": mutationVariable
    };

    var result = await httpClient.post(
      graphQLUrl,
      body: json.encode(body),
      headers: {
        "content-type": "application/json",
        "authorization": "Bearer $token"
      },
    );

    print(result);
    var data = json.decode(result.body)["data"];
    print(data);
    var orderID =  data["addOrder"]["orderID"];
    return orderID;
  }

  Future<Order> getOrder(int id) async {
    final String getOrderQuery = ''' 
    {
      order(id: $id) {
        total
        percentPaymentOption
        percentShipmentOption
        orderState {
          orderStateID
          name
        }
        branch_Navigation{
          address
          name
          branchID
          city
          province
        }
        paymentOption_Navigation{
          paymentOptionID
          name
          percent
        }
        shipmentOption_Navigation{
          shipmentOptionID
          name
          percent
        }
        itemOrders{
          packingID
          productID
          saleID
          subtotal
          quantity
          packing_Navigation{
            packingID
            productID
            name
            price
            quantity
            product: product_Navigation{
              productID
              name
              image
            }
          }
          sale_Navigation{
          	saleID
            name
            price
            image
            packings{
            packingID
    	      quantity
    	      productID
    	      saleID
    	      packing:packing_Navigation{
    		    packingID
                name
                hasStock
                priceLists{
                  price
                  priceList_Navigation{
                  code
                  }
                }  
                product:product_Navigation{
                  name
              	  image
               }
       	     }
            }
          }
        }
      }
    }
    ''';

    final getOrderResponse = await makeCall(getOrderQuery);
    final Order order = Order.fromJson(getOrderResponse['order']);
    return order;
  }

  Future changePassword(ChangePassword changePassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? null;
      final String changePasswordUrl = '$customerUrl/changepassword';

      final changePasswordResponse = await httpClient.post(changePasswordUrl,
          body: json.encode(changePassword),
          headers: {
            "content-type": "application/json",
            "authorization": "Bearer $token"
          });

      if (changePasswordResponse.statusCode != 200)
        throw Exception(json.decode(changePasswordResponse.body));
    } catch (_) {
      throw Exception('Error inesperado');
    }
  }

  Future<List<Order>> getOrders(String id) async {
    final String query = '''
    {
      orders(id: "$id") {
        orderID
        total
        percentPaymentOption
        percentShipmentOption
        orderState {
          orderStateID
          name
        }
        itemOrders {
          packing_Navigation { 
            name
            productID
            product:product_Navigation{
              name
            }
          }
          sale_Navigation{
            name
            saleID
          }
        }
      }
    }
    ''';

    final response = await makeCall(query);

    final List<Order> orders = (response['orders'] as List)
    .map( (o) => Order.fromJson(o))
    .toList();

    return orders;
  }

  makeCall(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? null;
    
    Map<String, String> body = {"query": query};
    print(json.encode(body));
    final response = await httpClient.post(graphQLUrl,
        body: json.encode(body),
        headers: {
          "content-type": "application/json",
          "authorization": "Bearer $token"
        });

    var a = json.decode(response.body)["data"];
    return a;
  }
}
