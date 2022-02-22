import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/models/address.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const getAddressByUserGraphQL = """
  query {
    getAddressByUser {
      addressId,
      city,
      streetName,
      streetNumber,
      floorNumber,
      apartmentNumber,
    }
  }
""";

const getAddressByIDGrpahql = """
  query {
    getAddressByID(\$addressId: Float!) {
      addressId,
    }
  }
""";

const createAddressGraphQL = """
  mutation 
    createAddress(\$createAddressInput: CreateAddressInput!) {
      createAddress(createAddressInput: \$createAddressInput) {
        addressId
        city,
        streetName,
        streetNumber,
        floorNumber,
        apartmentNumber,
      }
    }
""";

const updateAddressGraphQL = """
  mutation 
    updateAddress(\$addressId: Float!, \$updateAddressInput: UpdateAddressInput!) {
      updateAddress(addressId: \$addressId, updateAddressInput: \$updateAddressInput) {
        addressId,
        city,
        streetName,
        streetNumber,
        floorNumber,
        apartmentNumber
      }
    }
""";

const deleteAddressGraphQL = """
  mutation 
    deleteAddress(\$addressId: Float!) {
      deleteAddress(addressId: \$addressId)
    }
""";

const addressItemFromBackGraphql = """
  query {
    addressItemToFront(\$fromSetting: Boolean!)
  }
""";

class AddressProvider extends ChangeNotifier {
  List<Address> _addresses = [];

  Future<Address> getAddressByID(int addressId) async {
    QueryOptions queryOptions = QueryOptions(
        document: gql(getAddressByIDGrpahql),
        variables: <String, dynamic>{
          "addressId": addressId,
        });
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final dbAddress = result.data?['getAddressByID'];
    final address = Address.fromJson(dbAddress);
    return address;
  }

  Future<List<Address>> get getAddressByUser async {
    QueryOptions queryOptions =
        QueryOptions(document: gql(getAddressByUserGraphQL));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    _addresses = (result.data?['getAddressByUser']
        .map<Address>((addressJson) => Address.fromJson(addressJson))).toList();
    notifyListeners();
    return _addresses;
  }

  Future<Address> createAddress(Address address) async {
    String? city = address.city;
    String? streetName = address.streetName;
    int? streetNumber = address.streetNumber;
    int? floorNumber = address.floorNumber;
    int? apartmentNumber = address.apartmentNumber;

    MutationOptions queryOptions = MutationOptions(
        document: gql(createAddressGraphQL),
        variables: <String, dynamic>{
          "createAddressInput": {
            "city": city,
            "streetName": streetName,
            "streetNumber": streetNumber,
            "floorNumber": floorNumber,
            "apartmentNumber": apartmentNumber,
          }
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final resultData = result.data?["createAddress"];
    final add = Address.fromJson(resultData);
    notifyListeners();
    return add;
  }

  Future<Address> updateAddress(int addressId, Address editAddress) async {
    String? city = editAddress.city;
    String? streetName = editAddress.streetName;
    int? streetNumber = editAddress.streetNumber;
    int? floorNumber = editAddress.floorNumber;
    int? apartmentNumber = editAddress.apartmentNumber;

    MutationOptions queryOptions = MutationOptions(
        document: gql(updateAddressGraphQL),
        variables: <String, dynamic>{
          "addressId": addressId,
          "updateAddressInput": {
            "city": city,
            "streetName": streetName,
            "streetNumber": streetNumber,
            "floorNumber": floorNumber,
            "apartmentNumber": apartmentNumber,
          }
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final resultData = result.data?["updateAddress"];
    final address = Address.fromJson(resultData);
    notifyListeners();
    return address;
  }

  Future<bool> deleteAddress(int addressId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(deleteAddressGraphQL),
        variables: <String, dynamic>{
          "addressId": addressId,
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final isDeleted = result.data?["deleteAddress"];
    notifyListeners();
    return isDeleted;
  }

  Future<bool> addressItemFromBack(bool fromSettings) async {
    QueryOptions queryOptions = QueryOptions(
        document: gql(addressItemFromBackGraphql),
        variables: <String, dynamic>{
          "fromSettings": fromSettings,
        });
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final isFromFront = result.data?['addressItemToFront'];
    return isFromFront;
  }
}
