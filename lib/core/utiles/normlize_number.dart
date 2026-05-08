String normalizePhone(String phone) {
  phone = phone.trim().replaceAll(' ', '');

  if (phone.startsWith('0')) {
    phone = phone.substring(1);
  }

  return phone;
}