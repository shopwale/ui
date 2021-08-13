import 'package:shared/models/lib/customer.dart';
import 'package:shared/services/lib/db.dart';

class CustomerService {
  Future<Customer> getCustomerByMobileNumber(int mobileNumber) async {
    final response = await DbClient('getCustomerInfo').get(queryParams: {
      'customerMobile': mobileNumber.toString(),
    });
    return Customer.fromJson(response);
  }

  Future<Customer> getCustomerById(int id) async {
    // http://localgenie.in:3001/getCustomerInfo?customerId=1
    final response =
        await DbClient('getCustomerInfo', serverPort: 3001).get(queryParams: {
      'customerId': id.toString(),
    });
    return Customer.fromJson(response);
  }
}

class FakeCustomerService extends CustomerService {
  @override
  Future<Customer> getCustomerByMobileNumber(int mobileNumber) =>
      Future.value(_getCustomer());
  @override
  Future<Customer> getCustomerById(int id) => Future.value(_getCustomer());

  Customer _getCustomer() {
    return Customer(
      id: 1,
      mobileNumber: 9876556789,
      address: '100 Kumar Road',
      customerName: 'Naresh',
      pinCode: 123456,
    );
  }
}
