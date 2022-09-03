import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/models/my_models.dart';

class SharedPreferenceKullanimi extends StatefulWidget {
  const SharedPreferenceKullanimi({Key? key}) : super(key: key);

  @override
  State<SharedPreferenceKullanimi> createState() =>
      _SharedPreferenceKullanimiState();
}

class _SharedPreferenceKullanimiState extends State<SharedPreferenceKullanimi> {
  var _secilenCinsiyet = Cinsiyet.KADIN;
  var _secilenRenkler = <String>[];
  var _ogrenciMi = false;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verileriOku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared Pref Kullanimi'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Adınızı Giriniz:"),
            ),
          ),
          for (var item in Cinsiyet.values)
            _buildRadioListTiles(describeEnum(item), item),
          for (var item in Renkler.values) _buildCheckBoxListTile(item),
          SwitchListTile(
              title: const Text("Öğrenci Misin?"),
              value: _ogrenciMi,
              onChanged: (bool ogrenciMi) {
                setState(() {
                  _ogrenciMi = ogrenciMi;
                });
              }),
          TextButton(onPressed: _verileriKaydet, child: const Text("Kaydet"))
        ],
      ),
    );
  }

  void _verileriKaydet() async {
    final _name = _nameController.text;
    final preferences = await SharedPreferences.getInstance();

    preferences.setString("isim", _name);
    preferences.setBool("ogrenci", _ogrenciMi);
    preferences.setInt("cinsiyet", _secilenCinsiyet.index);
    preferences.setStringList("renkler", _secilenRenkler);
    debugPrint(_secilenCinsiyet.index.toString() +
        "ogrenciMi:" +
        _ogrenciMi.toString() +
        " Renkler:" +
        _secilenRenkler.toString());
  }

  void _verileriOku() async {
    final preferences = await SharedPreferences.getInstance();
    _nameController.text = preferences.getString("isim") ?? "";
    _ogrenciMi = preferences.getBool("öğrenci") ?? false;
    _secilenCinsiyet = Cinsiyet.values[preferences.getInt("cinsiyet") ?? 0];
    _secilenRenkler = preferences.getStringList("renkler") ?? <String>[];
    setState(() {});
  }

  Widget _buildCheckBoxListTile(Renkler renk) {
    return CheckboxListTile(
      title: Text(describeEnum(renk)),
      value: _secilenRenkler.contains(describeEnum(renk)),
      onChanged: (bool? deger) {
        if (deger == false) {
          _secilenRenkler.remove(describeEnum(renk));
        } else {
          _secilenRenkler.add(describeEnum(renk));
        }
        setState(
          () {
            debugPrint(_secilenRenkler.toString());
          },
        );
      },
    );
  }

  Widget _buildRadioListTiles(String title, Cinsiyet cinsiyet) {
    return RadioListTile(
      title: Text(title),
      value: cinsiyet,
      groupValue: _secilenCinsiyet,
      onChanged: (Cinsiyet? secilmisCinsiyet) {
        setState(
          () {
            _secilenCinsiyet = secilmisCinsiyet!;
          },
        );
      },
    );
  }
}
