import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(SportMatchApp());
}

class SportMatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SportMatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sports_soccer, size: 120, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                "Bem-vindo ao SportMatch ⚽🏀🏐",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                "Encontre pessoas que amam os mesmos esportes que você e jogue junto!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                child: Text("Começar", style: TextStyle(fontSize: 18)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _screens = [
    ExploreScreen(),
    EventsScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explorar"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Eventos"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}

class ExploreScreen extends StatelessWidget {
  final sports = ["Futebol", "Vôlei", "Corrida", "Tênis", "Basquete"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Explorar Esportes")),
      body: ListView.builder(
        itemCount: sports.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.sports),
            title: Text(sports[index]),
            subtitle: Text("Encontre jogadores de ${sports[index]}"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {},
          );
        },
      ),
    );
  }
}

class EventsScreen extends StatelessWidget {
  final events = [
    {"title": "Pelada de Futebol", "desc": "Sábado às 10h no Parque Central"},
    {"title": "Jogo de Vôlei", "desc": "Domingo às 15h na Praia"},
    {"title": "Corrida de Rua", "desc": "Segunda às 7h no Lago"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Eventos Próximos")),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.event_available, color: Colors.blue),
            title: Text(events[index]["title"]!),
            subtitle: Text(events[index]["desc"]!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventDetailScreen(event: events[index])),
              );
            },
          );
        },
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  final Map<String, String> event;
  EventDetailScreen({required this.event});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event["title"]!)),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event["title"]!, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(event["desc"]!, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text("Participantes (fictício): João, Maria, Pedro", style: TextStyle(color: Colors.grey[700])),
            Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Você confirmou presença!")),
                  );
                },
                icon: Icon(Icons.check),
                label: Text("Confirmar Presença"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  int? idade;
  String? esporte;
  String? nivel;
  bool perfilSalvo = false;
  File? _fotoPerfil;
  final esportes = ["Futebol", "Vôlei", "Corrida", "Tênis", "Basquete"];
  final niveis = ["Iniciante", "Intermediário", "Avançado"];
  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );
    if (imagem != null) {
      setState(() {
        _fotoPerfil = File(imagem.path);
      });
    }
  }
  Future<void> _escolherOrigemImagem() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.blue),
                title: Text("Escolher da Galeria"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blue),
                title: Text("Tirar Foto"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              if (_fotoPerfil != null)
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text("Remover Foto"),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _fotoPerfil = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }
  Future<void> _salvarPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("nome", nome ?? "");
    await prefs.setInt("idade", idade ?? 0);
    await prefs.setString("esporte", esporte ?? "");
    await prefs.setString("nivel", nivel ?? "");
    if (_fotoPerfil != null) {
      await prefs.setString("fotoPerfil", _fotoPerfil!.path);
    } else {
      await prefs.remove("fotoPerfil");
    }
    setState(() {
      perfilSalvo = true;
    });
  }
  Future<void> _carregarPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nome = prefs.getString("nome");
      idade = prefs.getInt("idade");
      esporte = prefs.getString("esporte");
      nivel = prefs.getString("nivel");
      String? caminhoFoto = prefs.getString("fotoPerfil");
      if (caminhoFoto != null && File(caminhoFoto).existsSync()) {
        _fotoPerfil = File(caminhoFoto);
      }
      perfilSalvo = nome != null && nome!.isNotEmpty;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meu Perfil")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: perfilSalvo ? _buildPerfil() : _buildFormulario(),
      ),
    );
  }
  Widget _buildPerfil() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _escolherOrigemImagem,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: _fotoPerfil != null ? FileImage(_fotoPerfil!) : null,
            child: _fotoPerfil == null
                ? Text(
                    nome![0].toUpperCase(),
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  )
                : null,
          ),
        ),
        SizedBox(height: 20),
        Text(nome ?? "", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text("${idade ?? 0} anos"),
        SizedBox(height: 10),
        Text("🏅 Esporte favorito: $esporte"),
        Text("⚡ Nível: $nivel"),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            setState(() {
              perfilSalvo = false;
            });
          },
          child: Text("Editar Perfil"),
        )
      ],
    );
  }
  Widget _buildFormulario() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Text("Cadastro de Perfil", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          GestureDetector(
            onTap: _escolherOrigemImagem,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _fotoPerfil != null ? FileImage(_fotoPerfil!) : null,
              child: _fotoPerfil == null
                  ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                  : null,
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(labelText: "Nome"),
            onSaved: (value) => nome = value ?? "",
            validator: (value) => value!.isEmpty ? "Digite seu nome" : null,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Idade"),
            keyboardType: TextInputType.number,
            onSaved: (value) => idade = int.tryParse(value ?? "0") ?? 0,
            validator: (value) => value!.isEmpty ? "Digite sua idade" : null,
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "Esporte favorito"),
            value: esporte ?? "Futebol",
            items: esportes
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) => setState(() => esporte = value),
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "Nível"),
            value: nivel ?? "Iniciante",
            items: niveis
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) => setState(() => nivel = value),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _salvarPerfil();
              }
            },
            child: Text("Salvar Perfil"),
          )
        ],
      ),
    );
  }
}
