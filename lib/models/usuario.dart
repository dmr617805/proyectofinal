class Usuario {
  final String username;
  final String password;
  
  Usuario({required this.username, required this.password});
}

List<Usuario> usuarios = [
  Usuario(username: 'admin', password: 'admin'),
  Usuario(username: 'user', password: 'user'),
  Usuario(username: 'guest', password: 'guest'),
];