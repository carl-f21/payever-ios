Map<String, String> sortTransactions = {
'total_high': 'Total high',
'total_low': 'Total low',
'customer_name': 'Customer Name',
'date': 'Date',
};

Map<String, String> filterLabels = {
  'amount': 'Amount',
  'channel': 'Channel',
  'currency': 'Currency',
  'original_id': 'Id',
  'reference': 'Reference',
  'total': 'Total',
  'type': 'Payment type',
  'customer_name': 'Customer name',
  'customer_email': 'Customer email',
  'merchant_email': 'Merchant email',
  'merchant_name': 'Merchant name',
  'seller_email': 'Seller email',
  'seller_name': 'Seller name',
  'created_at': 'Date',
  'status': 'Status',
  'specific_status': 'Specific status',
};

Map<String, String> filterConditions = {
  'is': 'Is',
  'isNot': 'Is not',
  'startsWith': 'Starts with',
  'endsWith': 'Ends with',
  'contains': 'Contains',
  'doesNotContain': 'Does not contain',
  'greaterThan': 'Greater than',
  'lessThan': 'Less than',
  'between': 'Between',
  'isDate': 'Is',
  'isNotDate': 'Is not',
  'afterDate': 'After',
  'beforeDate': 'Before',
  'betweenDates': 'Between'
};

Map<String, String> paymentTypeOptions = {
  'sofort': 'SOFORT Banking',
  'invoice': 'Invoice',
  'cash': 'Wire Transfer',
  'paymill_creditcard': 'Paymill Credit Card',
  'paymill_directdebit': 'Direct Debit',
  'paypal': 'PayPal',
  'stripe': 'Credit Card',
  'santander_installment': 'Santander Installments',
  'santander_pos_installment': 'POS Santander Installments',
  'santander_installment_no': 'Santander Installments Norway',
  'santander_pos_installment_no': 'POS Santander Installments Norway',
  'santander_invoice_no': 'Santander Invoice Norway',
  'santander_pos_invoice_no': 'POS Santander Invoice Norway',
  'santander_installment_dk': 'Santander Installments Denmark',
  'santander_installment_se': 'Santander Installments Sweden',
  'payex_faktura': 'PayEx Invoice',
  'santander_ccp_installment': 'Santander DE Comfort card plus',
  'payex_creditcard': 'PayEx Credit Card',
  'stripe_directdebit': 'Stripe DirectDebit',
  'santander_invoice_de': 'Santander DE Invoice',
  'santander_pos_invoice_de': 'POS Santander DE Invoice',
  'santander_pos_installment_se': 'POS Santander Installments Sweden',
  'santander_factoring_de': 'Santander Factoring',
  'santander_pos_factoring_de': 'POS Santander Factoring',
  'instant_payment': 'Instant Payment'
};

Map<String, String> specificStatusOption = {
  'STATUS_NEW': 'New',
  'STATUS_IN_PROCESS': 'In progress',
  'STATUS_ACCEPTED': 'Accepted',
  'STATUS_PAID': 'Paid',
  'STATUS_DECLINED': 'Declined',
  'STATUS_REFUNDED': 'Refunded',
  'STATUS_FAILED': 'Failed',
  'STATUS_CANCELLED': 'Cancelled',
  'STATUS_INVOICE_CANCELLATION': 'Cancelled',
  'STATUS_INVOICE_INCOLLECTION': 'Collection',
  'STATUS_INVOICE_LATEPAYMENT': 'Late payment',
  'STATUS_INVOICE_REMINDER': 'Reminder',
  'STATUS_SANTANDER_IN_PROGRESS': 'In progress',
  'STATUS_SANTANDER_IN_PROCESS': 'In process',
  'STATUS_SANTANDER_DECLINED': 'Declined',
  'STATUS_SANTANDER_APPROVED': 'Approved',
  'STATUS_SANTANDER_APPROVED_WITH_REQUIREMENTS': 'Approved with requirements',
  'STATUS_SANTANDER_DEFERRED': 'Deferred',
  'STATUS_SANTANDER_CANCELLED': 'Cancelled',
  'STATUS_SANTANDER_AUTOMATIC_DECLINE': 'Automatically declined',
  'STATUS_SANTANDER_IN_DECISION': 'In decision',
  'STATUS_SANTANDER_DECISION_NEXT_WORKING_DAY': 'Decision in the next working day',
  'STATUS_SANTANDER_IN_CANCELLATION': 'In cancellation',
  'STATUS_SANTANDER_ACCOUNT_OPENED': 'Account opened',
  'STATUS_SANTANDER_CANCELLED_ANOTHER': 'Cancelled',
  'STATUS_SANTANDER_SHOP_TEMPORARY_APPROVED': 'Temporarily approved',
};
Map<String, String> filterChannelOption = {
  'shopify': 'Shopify',
  'facebook': 'Facebook',
  'finance_express': 'Finance express',
  'store': 'Store',
  'wooCommerce': 'WooCommerce',
  'magento': 'Magento',
  'marketing': 'Marketing',
  'pos': 'PoS',
  'shopware': 'Shopware',
  'debitoor': 'Debitoor',
  'link': 'Link',
  'e-conomic': 'E-conomic',
  'jtl': 'JTL',
  'oxid': 'OXID',
  'weebly': 'Weebly',
  'plentymarkets': 'Plentymarkets',
  'advertising': 'Advertising',
  'offer': 'Offer',
  'dandomain': 'DanDomain',
  'presta': 'PrestaShop',
  'xt_commerce': 'xt:Commerce',
  'overlay': 'Overlay'
};
Map<String, String> filterStatusOption = {
  'STATUS_NEW': 'New',
  'STATUS_IN_PROCESS': 'In progress',
  'STATUS_ACCEPTED': 'Accepted',
  'STATUS_PAID': 'Paid',
  'STATUS_DECLINED': 'Declined',
  'STATUS_REFUNDED': 'Refunded',
  'STATUS_FAILED': 'Failed',
  'STATUS_CANCELLED': 'Cancelled'
};

String hintTextByFilter(String type) {
  switch (type) {
    case 'created_at':
      return 'Date';
    case 'type':
      return 'Option';
    case 'status':
      return 'Option';
    case 'specific_status':
      return 'Option';
    case 'channel':
      return 'Option';
    case 'currency':
      return 'Option';
    default:
      return 'Search';
  }
}

Map<String, String> filterConditionsByFilterType(String type) {
  switch (type) {
    case 'original_id':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'startsWith': 'Starts with',
        'endsWith': 'Ends with',
        'contains': 'Contains',
        'doesNotContain': 'Does not contain'
      };
    case 'reference':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'startsWith': 'Starts with',
        'endsWith': 'Ends with',
        'contains': 'Contains',
        'doesNotContain': 'Does not contain'
      };
    case 'created_at':
      return {
        'isDate': 'Is',
        'isNotDate': 'Is not',
        'afterDate': 'After',
        'beforeDate': 'Before',
        'betweenDates': 'Between'
      };
    case 'type':
      return {
        'is': 'Is',
        'isNot': 'Is not',
      };
    case 'status':
      return {
        'is': 'Is',
        'isNot': 'Is not',
      };
    case 'specific_status':
      return {
        'is': 'Is',
        'isNot': 'Is not',
      };
    case 'channel':
      return {
        'is': 'Is',
        'isNot': 'Is not',
      };
    case 'amount':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'greaterThan': 'Greater than',
        'lessThan': 'Less than',
        'between': 'Between',
      };
    case 'total':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'greaterThan': 'Greater than',
        'lessThan': 'Less than',
        'between': 'Between',
      };
    case 'currency':
      return {
        'is': 'Is',
        'isNot': 'Is not',
      };
    case 'customer_name':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'startsWith': 'Starts with',
        'endsWith': 'Ends with',
        'contains': 'Contains',
        'doesNotContain': 'Does not contain'
      };
    case 'customer_email':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'startsWith': 'Starts with',
        'endsWith': 'Ends with',
        'contains': 'Contains',
        'doesNotContain': 'Does not contain'
      };
    case 'merchant_email':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'startsWith': 'Starts with',
        'endsWith': 'Ends with',
        'contains': 'Contains',
        'doesNotContain': 'Does not contain'
      };
    case 'merchant_name':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'startsWith': 'Starts with',
        'endsWith': 'Ends with',
        'contains': 'Contains',
        'doesNotContain': 'Does not contain'
      };
    case 'seller_email':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'startsWith': 'Starts with',
        'endsWith': 'Ends with',
        'contains': 'Contains',
        'doesNotContain': 'Does not contain'
      };
    case 'seller_name':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'startsWith': 'Starts with',
        'endsWith': 'Ends with',
        'contains': 'Contains',
        'doesNotContain': 'Does not contain'
      };
    case 'title':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'startsWith': 'Starts with',
        'endsWith': 'Ends with',
        'contains': 'Contains',
        'doesNotContain': 'Does not contain'
      };
    case 'price':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'greaterThan': 'Greater than',
        'lessThan': 'Less than',
        'between': 'Between',
      };
    case 'weight':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'greaterThan': 'Greater than',
        'lessThan': 'Less than',
        'between': 'Between',
      };
    case 'id':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'startsWith': 'Starts with',
        'endsWith': 'Ends with',
        'contains': 'Contains',
        'doesNotContain': 'Does not contain'
      };
    case 'name':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'startsWith': 'Starts with',
        'endsWith': 'Ends with',
        'contains': 'Contains',
        'doesNotContain': 'Does not contain'
      };
    case 'variant_name':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'startsWith': 'Starts with',
        'endsWith': 'Ends with',
        'contains': 'Contains',
        'doesNotContain': 'Does not contain'
      };
    case 'category':
      return {
        'is': 'Is',
        'isNot': 'Is not',
      };
    default:
      return {};
  }
}

Map<String, String> getOptionsByFilterType(String type) {
  switch(type) {
    case 'type':
      return paymentTypeOptions;
    case 'status':
      return filterStatusOption;
    case 'specific_status':
      return specificStatusOption;
    case 'channel':
      return filterChannelOption;
  }
  return {};
}

String getOptionString(String key) {
  String temp = paymentTypeOptions.keys.toList().firstWhere((element) => element == key);
  if (temp != null) {
    return temp;
  }
  temp = filterStatusOption.keys.toList().firstWhere((element) => element == key);
  if (temp != null) {
    return temp;
  }
  temp = specificStatusOption.keys.toList().firstWhere((element) => element == key);
  if (temp != null) {
    return temp;
  }
  temp = filterChannelOption.keys.toList().firstWhere((element) => element == key);
  if (temp != null) {
    return temp;
  }
  return null;
}

List<String> productConditionOptions = [
  'No Conditions',
  'All Conditions',
  'Any Condition',
];

Map<String, String> conditionFields = {
  'title': 'Title',
  'type': 'Type',
  'price': 'Price',
  'weight': 'Weight',
};

Map<String, String> filterProducts = {
  'id': 'Product ID',
  'name': 'Product Name',
  'price': 'Price',
  'channel': 'Channel',
  'category': 'Category',
  'variant_name': 'Variant Name',
};

Map<String, String> sortProducts = {
  'default': 'Default',
  'name': 'Name',
  'price_low': 'Price Low to High',
  'price_high': 'Price High to Low',
  'date': 'By Date',
};
