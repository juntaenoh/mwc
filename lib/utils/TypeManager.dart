import 'package:mwc/utils/internationalization.dart';
import 'package:flutter/material.dart';

class TypeManager {
  String _type = '';
  String _typetitle = '';
  String _typescript = '';
  String _typeavt = 'assets/body3d/Avata.glb';
  bool _typeok = true;

  void setType(BuildContext context, var typeint) {
    switch (typeint) {
      case 0:
        _type = SetLocalizations.of(context).getText('footprintTypeLabel0');
        _typeavt = 'assets/body3d/Avata.glb';
        _typetitle = SetLocalizations.of(context).getText('footprintTitle0');
        _typescript = SetLocalizations.of(context).getText('footprintScript0');
        _typeok = true;
        break;
      case 1:
        _type = SetLocalizations.of(context).getText('footprintTypeLabel1');
        _typeavt = 'assets/body3d/Avata.glb';
        _typetitle = SetLocalizations.of(context).getText('footprintTitle1');
        _typescript = SetLocalizations.of(context).getText('footprintScript1');
        _typeok = true;
        break;
      case 2:
        _type = SetLocalizations.of(context).getText('footprintTypeLabel2');
        _typeavt = 'assets/body3d/Avata.glb';
        _typetitle = SetLocalizations.of(context).getText('footprintTitle2');
        _typescript = SetLocalizations.of(context).getText('footprintScript2');
        _typeok = true;
        break;
      case 3:
        _type = SetLocalizations.of(context).getText('footprintTypeLabel3');
        _typeavt = 'assets/body3d/Avata_front.glb';
        _typetitle = SetLocalizations.of(context).getText('footprintTitle3');
        _typescript = SetLocalizations.of(context).getText('footprintScript3');
        _typeok = true;
        break;
      case 4:
        _type = SetLocalizations.of(context).getText('footprintTypeLabel4');
        _typeavt = 'assets/body3d/Avata_back.glb';
        _typetitle = SetLocalizations.of(context).getText('footprintTitle4');
        _typescript = SetLocalizations.of(context).getText('footprintScript4');
        _typeok = true;
        break;
      case 5:
        _type = SetLocalizations.of(context).getText('footprintTypeLabel5');
        _typeavt = 'assets/body3d/Avata_left.glb';
        _typetitle = SetLocalizations.of(context).getText('footprintTitle5');
        _typescript = SetLocalizations.of(context).getText('footprintScript5');
        _typeok = true;
        break;
      case 6:
        _type = SetLocalizations.of(context).getText('footprintTypeLabel6');
        _typeavt = 'assets/body3d/Avata_right.glb';
        _typetitle = SetLocalizations.of(context).getText('footprintTitle6');
        _typescript = SetLocalizations.of(context).getText('footprintScript6');
        _typeok = true;
        break;
      case 7:
        _type = SetLocalizations.of(context).getText('footprintTypeLabel7');
        _typeavt = 'assets/body3d/Avata_roll.glb';
        _typetitle = SetLocalizations.of(context).getText('footprintTitle7');
        _typescript = SetLocalizations.of(context).getText('footprintScript7');
        _typeok = true;
        break;
      default:
        _type = SetLocalizations.of(context).getText('footprintTypeLabel8');
        _typeavt = 'assets/body3d/Avata.glb';
        _typetitle = SetLocalizations.of(context).getText('footprintTitle8');
        _typescript = SetLocalizations.of(context).getText('footprintScript8');
        _typeok = false;
    }
  }

  String get type => _type;
  String get typeAvt => _typeavt;
  String get typeTitle => _typetitle;
  String get typeScript => _typescript;
  bool get typeOk => _typeok;
}
