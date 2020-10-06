import 'package:andina_protos/api/api.client.dart';
import 'package:andina_protos/blocs/authentication/authentication.dart';
import 'package:andina_protos/repositories/category.repository.dart';
import 'package:andina_protos/repositories/checkout.repository.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:andina_protos/repositories/order.repository.dart';
import 'package:andina_protos/repositories/products.repository.dart';
import 'package:andina_protos/repositories/sales.repository.dart';
import 'package:andina_protos/screens/branch_edit.dart';
import 'package:andina_protos/screens/checkout.dart';
import 'package:andina_protos/screens/dashboard_page.dart';
import 'package:andina_protos/screens/login_page.dart';
import 'package:andina_protos/screens/order_detail.dart';
import 'package:andina_protos/screens/orders.dart';
import 'package:andina_protos/screens/password_change.dart';
import 'package:andina_protos/screens/products.dart';
import 'package:andina_protos/screens/profile.dart';
import 'package:andina_protos/screens/saleDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

import 'blocs/cart/cart.dart';
import 'blocs/cart/cart_bloc.dart';
import 'blocs/profile/profile.dart';
import 'screens/sales.dart';

Future<void> main() async {
  await DotEnv().load('.env');
  final ProductsRepository productsRepository =
      ProductsRepository(apiClient: ApiClient(httpClient: http.Client()));
  final CategoryRepository categoryRepository =
      CategoryRepository(apiClient: ApiClient(httpClient: http.Client()));
  final CustomerRepository customerRepository =
      CustomerRepository(apiClient: ApiClient(httpClient: http.Client()));
  final CheckoutRepository checkoutRepository =
      CheckoutRepository(apiClient: ApiClient(httpClient: http.Client()));
  final OrderRepository orderRepository =
      OrderRepository(apiClient: ApiClient(httpClient: http.Client()));
  final SalesRepository salesRepository =
      SalesRepository(apiClient: ApiClient(httpClient: http.Client()));

  runApp(MyApp(
      productsRepository: productsRepository,
      categoryRepository: categoryRepository,
      customerRepository: customerRepository,
      checkoutRepository: checkoutRepository,
      orderRepository: orderRepository,
      salesRepository: salesRepository));
}

class MyApp extends StatefulWidget {
  final ProductsRepository productsRepository;
  final CategoryRepository categoryRepository;
  final CustomerRepository customerRepository;
  final CheckoutRepository checkoutRepository;
  final OrderRepository orderRepository;
  final SalesRepository salesRepository;

  const MyApp(
      {Key key,
      @required this.productsRepository,
      @required this.categoryRepository,
      @required this.customerRepository,
      @required this.checkoutRepository,
      @required this.orderRepository,
      @required this.salesRepository})
      : assert(productsRepository != null),
        assert(categoryRepository != null),
        assert(customerRepository != null),
        assert(checkoutRepository != null),
        assert(orderRepository != null),
        assert(salesRepository != null),
        super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthenticationBloc _authenticationBloc;
  CartBloc _cartBloc;
  ProfileBloc _profileBloc;

  ProductsRepository get _productsRepository => widget.productsRepository;
  CategoryRepository get _categoryRepository => widget.categoryRepository;
  CustomerRepository get _customerRepository => widget.customerRepository;
  CheckoutRepository get _checkoutRepository => widget.checkoutRepository;
  OrderRepository get _orderRepository => widget.orderRepository;
  SalesRepository get _salesRepository => widget.salesRepository;

  @override
  void initState() {
    _cartBloc = CartBloc(
        checkoutRepository: _checkoutRepository,
        customerRepository: _customerRepository,
        orderRepository: _orderRepository);
    _authenticationBloc =
        AuthenticationBloc(customerRepository: _customerRepository);
    _profileBloc = ProfileBloc(customerRepository: _customerRepository);
    _authenticationBloc.dispatch(AppStarted());

    super.initState();
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    _cartBloc.dispose();
    _profileBloc.dispose();
    super.dispose();
  }

  void _initializeCart() {
    _cartBloc.dispatch(InitializeCart());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<AuthenticationBloc>(
            builder: (BuildContext context) => _authenticationBloc),
        BlocProvider<CartBloc>(builder: (BuildContext context) => _cartBloc,),
        BlocProvider<ProfileBloc>(
            builder: (BuildContext context) => _profileBloc)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        routes: {
          '/dashboard': (BuildContext context) => DashboardPage(
                initializeCart: _initializeCart,
              ),
          '/checkout': (BuildContext context) => Checkout(
                customerRepository: _customerRepository,
                checkoutRepository: _checkoutRepository,
              ),
          '/orders': (BuildContext context) => OrdersScreen(
                customerRepository: _customerRepository,
              ),
          '/orderDetail': (BuildContext context) => OrderDetail(
                id: ModalRoute.of(context).settings.arguments,
                orderRepository: _orderRepository,
              ),
          '/products': (BuildContext context) => ProductsScreen(
                customerRepository: _customerRepository,
                checkoutRepository: _checkoutRepository,
                productRepository: _productsRepository,
                categoryRepository: _categoryRepository,
                salesRepository: _salesRepository,
              ),
          '/sales': (BuildContext context) => SalesScreem(
                salesRepository: _salesRepository,
              ),
          '/profile': (BuildContext context) => ProfileScreen(),
          '/branch/new': (BuildContext context) => BranchEdit(),
          '/saleDetail': (BuildContext context) => SaleDetail(),
          '/password': (BuildContext context) => PasswordChangeScreen(
                customerRepository: _customerRepository,
              )
          // '/login': (BuildContext context) => LoginPage(customerRepository: _customerRepository)
        },
        theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: 'Times New Roman'
        ),
        // home: LoginPage(),
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            // if(state is AuthenticationUninitialized) {
            //   return SplashPage();
            // }

            if (state is AuthenticationLoading ||
                state is AuthenticationUninitialized) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is AuthenticationUnauthenticated) {
              return LoginPage(
                customerRepository: _customerRepository,
              );
            }

            if (state is AuthenticationAuthenticated) {
              return DashboardPage(
                initializeCart: _initializeCart,
              );
            }

            return Center(
              child: Text('Ocurrio un error inesperado'),
            );
          },
        ),
      ),
    );
  }
}
