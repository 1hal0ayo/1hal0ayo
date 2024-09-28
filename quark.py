# /quark/__init__.py

def encrypt_data(data, key):
    from cryptography.fernet import Fernet
    fernet = Fernet(key)
    encrypted = fernet.encrypt(data.encode())
    return encrypted

def decrypt_data(encrypted_data, key):
    from cryptography.fernet import Fernet
    fernet = Fernet(key)
    decrypted = fernet.decrypt(encrypted_data).decode()
    return decrypted
  
