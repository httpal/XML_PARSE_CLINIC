// программа XML парсер - поликлиника
import std.stdio;
import std.file;
import std.string;
import std.encoding;
import std.conv;
import std.algorithm;
import std.array;
import std.utf;
import std.uni;
import std.datetime;
import std.zip;
import std.zlib;
import std.regex;
import std.process;
import kxml.xml;
import funcs;


string L_FLK_PRTKL(string OSHIB, string IM_POL, string BAS_EL, string NHISTORY, string ID_PAC, string COMMENT){
	string XML_STR = "";
	if(OSHIB!=""){XML_STR = XML_STR ~ "\t\t<OSHIB>" ~ OSHIB ~ "</OSHIB>\n";}
	if(IM_POL!=""){XML_STR = XML_STR ~ "\t\t<IM_POL>" ~ IM_POL ~ "</IM_POL>\n";}
	if(BAS_EL!=""){XML_STR = XML_STR ~ "\t\t<BAS_EL>" ~ BAS_EL ~ "</BAS_EL>\n";}
	if(NHISTORY!=""){XML_STR = XML_STR ~ "\t\t<NHISTORY>" ~ NHISTORY ~ "</NHISTORY>\n";}
	if(ID_PAC!=""){XML_STR = XML_STR ~ "\t\t<ID_PAC>" ~ ID_PAC ~ "</ID_PAC>\n";}
	if(COMMENT!=""){XML_STR = XML_STR ~ "\t\t<COMMENT>" ~ COMMENT ~ "</COMMENT>\n";}
	if(XML_STR!=""){
		XML_STR = "\t<PR>\n" ~ XML_STR;
		XML_STR = XML_STR ~ "\t</PR>\n";
	}
	return XML_STR;
	}
string H_FLK_PRTKL(string OSHIB, string IM_POL, string BAS_EL, string N_ZAP,
				 string IDCASE, string IDSERV, string NHISTORY, string COMMENT){
	string XML_STR = "";
	if(OSHIB!=""){XML_STR = XML_STR ~ "\t\t<OSHIB>" ~ OSHIB ~ "</OSHIB>\n";}
	if(IM_POL!=""){XML_STR = XML_STR ~ "\t\t<IM_POL>" ~ IM_POL ~ "</IM_POL>\n";}
	if(BAS_EL!=""){XML_STR = XML_STR ~ "\t\t<BAS_EL>" ~ BAS_EL ~ "</BAS_EL>\n";}
	if(N_ZAP!=""){XML_STR = XML_STR ~ "\t\t<N_ZAP>" ~ N_ZAP ~ "</N_ZAP>\n";}
	if(IDCASE!=""){XML_STR = XML_STR ~ "\t\t<IDCASE>" ~ IDCASE ~ "</IDCASE>\n";}
	if(IDSERV!=""){XML_STR = XML_STR ~ "\t\t<IDSERV>" ~ IDSERV ~ "</IDSERV>\n";}
	if(NHISTORY!=""){XML_STR = XML_STR ~ "\t\t<NHISTORY>" ~ NHISTORY ~ "</NHISTORY>\n";}
	if(COMMENT!=""){XML_STR = XML_STR ~ "\t\t<COMMENT>" ~ COMMENT ~ "</COMMENT>\n";}
	if(XML_STR!=""){
		XML_STR = "\t<PR>\n" ~ XML_STR;
		XML_STR = XML_STR ~ "\t</PR>\n";
	}
	return XML_STR;
}

int find_idx(string[][] array_, string search_field, string sub_field, ref int i){
	bool flag = false;
	if (search_field == ""){
		i = -1;
		return i;
	}
	for (i=0; i<array_[0].length; i++) {
		if(sicmp(array_[0][i],search_field) == 0 && sicmp(array_[1][i],sub_field) == 0){
			flag = true;
			break;
		}
	}
	if(flag == false) {
		i = -1;
	}
	return i;
}

// В этой структуре одна запись - один человек
struct LM_XML_STRUCT {
	string ID_PAC,FAM,IM,OT,W,DR,FAM_P,IM_P,OT_P,W_P,DR_P,MR,DOCTYPE,DOCSER,DOCNUM,SNILS,OKATOG,OKATOP,COMENTP;
}
// В этой структуре несколько записей - один человек или одна запись - один человек
struct HM_XML_STRUCT {
	string 	N_ZAP,PR_NOV,ID_PAC,VPOLIS,SPOLIS,NPOLIS,ST_OKATO,SMO,SMO_OGRN,SMO_OK,SMO_NAM,NOVOR,IDCASE,USL_OK,VIDPOM,
			FOR_POM,NPR_MO,EXTR,//PODR,LPU,LPU1,PROFIL,DET,
			NHISTORY,DATE_1,DATE_2,DS0,DS1,DS2,CODE_MES1,CODE_MES2,RSLT,ISHOD,// PRVS,
			IDDOKT,OS_SLUCH,IDSP,ED_COL,UET,// TARIF,
			SUMV,OPLATA,IDSERV,LPU,LPU1,PODR,PROFIL,DET,DATE_IN,DATE_OUT,DS,CODE_USL,KOL_USL,UET_USL,
			PRVD,TARIF,SUMV_USL,PRVS,CODE_MD,COMENTU,COMENTSL;
}
// Эта структура - аналог таблицы на сервере. Используем ее для наглядности.
struct RCLINUP1 {
	string 	NUM,STNUM,FAMILY,NAME,NAME2,DBIRTH,SEX,C_DOC,S_DOC,N_DOC,WORK,JOB_NAM,C_OKSM,REGION,DISTRICT,TOWN,STREET,
			HOUSE,APART,CODESTREET,KODR,STAT_Z,STAT_P,PARENT,SUMM,POLISSER,POLISN,DATE_N,DATE_E,Q_OGRN,INSU,KODH,KO,
			NYS,NKOL,KEY2,UET,DATE,NUMBER1,FAM,SSD,PRVD,D,PRVS,KODRES,D_LISTIN,D_LISTOUT,CU,SUM,KODAB1,TRAWMA,PRMP,
			N_ZAP,IDCASE;
}
//-------------------------------------------------------------------------------------------------------------------

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// ВНИМАНИЕ!!! СО СТРУКТУРАМИ ПОЛУЧАЕТСЯ БЫСТРЕЕ ЧЕМ С МАССИВАМИ
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

int main(string[] args){ 
	//args = ["XML_FLK", 	"E:/DBF_Files/galmel/xml_ctmp/LM39025P2516112.XML",
	//					"E:/DBF_Files/galmel/xml_ctmp/HM39025P2516112.XML",
	//					"E:/dbf_files/galmel/FORMATFILE/RCLINUP1.dat",
	//					"E:/dbf_files/galmel/FORMATFILE/s_strcomp.tbl",
	//					"text_file.TXT"];

	string   xml_archive = "E:/xml/Miac/xml_archive/";
	string      xml_cflk = "E:/xml/Miac/XML_FLK/";
	string   xml_creserv = "E:/dbf_files/galmel/xml_creserv/";
	string      xml_ctmp = "E:/dbf_files/galmel/xml_ctmp/";
	//string    xml_clinic = "E:/dbf_files/galmel/clinic/";
	string    xml_clinic = "E:/dbf_files/galmel/clinic/";
	
	int return_var = 1;
	//if ("str" == "[s][t][r]"){
	//	writeln("pattern");
	//}
	//string ss = r"\b[0-9][0-9]\b";
	//auto r = regex(r"\b[0-9][0-9]\b");
	//auto r = regex(ss);
	//writeln(matchFirst("18", r));
	StopWatch sw;
	sw.start();	
	//writeln(""); if (return_var == 1) {writeln(sw.peek().msecs); return 1;}
	string fl_strcomp = args[4].toUpper;
	string fl_struct = args[3].toUpper;
	auto reestr_file_lm = args[1].toUpper;
	auto reestr_file_hm = args[2].toUpper;
	
	auto fldr_xml = reestr_file_lm[0..std.string.lastIndexOf(reestr_file_lm, "/")+1].toUpper;
	auto FM_NAME_FLK = "F" ~ reestr_file_lm[std.string.lastIndexOf(reestr_file_lm, "/")+2..$].toUpper;
	auto VM_NAME_FLK = "V" ~  reestr_file_hm[std.string.lastIndexOf(reestr_file_hm, "/")+2..$].toUpper;
	auto LM_NAME = reestr_file_lm[std.string.lastIndexOf(reestr_file_lm, "/")+1..$].toUpper;
	auto HM_NAME = reestr_file_hm[std.string.lastIndexOf(reestr_file_hm, "/")+1..$].toUpper;
	auto fldr_struct = fl_struct[0..std.string.lastIndexOf(fl_struct, "/")+1].toUpper;
	// Проверим существование заданных директорий и файлов и права на них
	assert(DirEntry(fldr_xml).isDir);
	assert(DirEntry(fldr_struct).isDir);
	assert(DirEntry(reestr_file_lm).isFile);
	assert(DirEntry(reestr_file_hm).isFile);
	assert(DirEntry(fl_struct).isFile);
	assert(DirEntry(fl_strcomp).isFile);
	// Получим массив-структуру таблицы сервера: RCLINUP1
	auto RCLINUP_DAT = GET_STRUCT_FROMDAT(readText(fl_struct));
	auto xml_str_lm = CP1251_UTF8(cast(string)std.file.read(reestr_file_lm), false);
	auto s_strcomp = TBLTXT_ARRAY(UBYTE_UTF8(read(fl_strcomp),false));
	try
	{
		readDocument(xml_str_lm);
	}
	catch {
		writeln(UTF8_CP866("Ошибка синтаксиса XML файла"));
		writeln();
		return 56;
	}	
	XmlNode[]xml_pers = readDocument(xml_str_lm).parseXPath("//PERS");
	auto LM_DATA = new LM_XML_STRUCT[](xml_pers.length);
	
	for (int i=0; i<xml_pers.length; i++) {
		for (int j=0; j<xml_pers[i].getChildren.length; j++) {
			switch (xml_pers[i].getChildren[j].getName.toUpper){
				case "ID_PAC": LM_DATA[i].ID_PAC = xml_pers[i].getChildren[j].getCData.text; break;
				case "FAM": LM_DATA[i].FAM = xml_pers[i].getChildren[j].getCData.text; break;
				case "IM": LM_DATA[i].IM = xml_pers[i].getChildren[j].getCData.text; break;
				case "OT": LM_DATA[i].OT = xml_pers[i].getChildren[j].getCData.text; break;
				case "W": LM_DATA[i].W = (xml_pers[i].getChildren[j].getCData.text == "1"? "м":"ж"); break;
				case "DR": LM_DATA[i].DR = xml_pers[i].getChildren[j].getCData.text; break;
				case "FAM_P": LM_DATA[i].FAM_P = xml_pers[i].getChildren[j].getCData.text; break;
				case "IM_P": LM_DATA[i].IM_P = xml_pers[i].getChildren[j].getCData.text; break;
				case "OT_P": LM_DATA[i].OT_P = xml_pers[i].getChildren[j].getCData.text; break;
				//case "W_P": LM_DATA[i].W_P = xml_pers[i].getChildren[j].getCData.text; break;
				//case "DR_P": LM_DATA[i].DR_P = xml_pers[i].getChildren[j].getCData.text; break;
				//case "MR": LM_DATA[i].MR = xml_pers[i].getChildren[j].getCData.text; break;
				case "DOCTYPE": LM_DATA[i].DOCTYPE = (xml_pers[i].getChildren[j].getCData.text==""? "0":xml_pers[i].getChildren[j].getCData.text); break;
				case "DOCSER": LM_DATA[i].DOCSER = xml_pers[i].getChildren[j].getCData.text; break;
				case "DOCNUM": LM_DATA[i].DOCNUM = xml_pers[i].getChildren[j].getCData.text; break;
				case "SNILS": LM_DATA[i].SNILS = xml_pers[i].getChildren[j].getCData.text.replace("-","").replace(" ",""); break;
				//case "OKATOG": LM_DATA[i].OKATOG = xml_pers[i].getChildren[j].getCData.text; break;
				//case "OKATOP": LM_DATA[i].OKATOP = xml_pers[i].getChildren[j].getCData.text; break;
				//case "COMENTP": LM_DATA[i].COMENTP = xml_pers[i].getChildren[j].getCData.text; break;
				default: break;
			}
		}
		//writeln(LM_DATA[i].ID_PAC, "\t" ,UTF8_CP866(LM_DATA[i].FAM), "\t" ,UTF8_CP866(LM_DATA[i].IM), "\t" ,UTF8_CP866(LM_DATA[i].OT));
	}
	//*/
	auto xml_str_hm = CP1251_UTF8(cast(string)std.file.read(reestr_file_hm), false);
	try
	{
		readDocument(xml_str_hm);
	}
	catch {
		writeln(UTF8_CP866("Ошибка синтаксиса XML файла"));
		writeln();
		return 56;
	}
	XmlNode[]xml_zap = readDocument(xml_str_hm).parseXPath("//ZAP");
	XmlNode[]xml_sluch;
	XmlNode[]xml_usl;
	XmlNode xml_doc = readDocument(xml_str_hm);
	auto count_usl = xml_doc.parseXPath("//USL").length;
	auto HM_DATA = new HM_XML_STRUCT[](count_usl);
	//writeln(xml_zap[0].getChildren[3].opIndex(30));
	int i = 0;
	int j = 0;
		
	//writeln(xml_zap.getName);
	//writeln(""); if (return_var == 1) {writeln(sw.peek().msecs); return 1;}

	//HM_DATA[i].NOVOR,HM_DATA[i].RSLT,HM_DATA[i].SPOLIS,	HM_DATA[i].NPOLIS,HM_DATA[i].DATE_2,HM_DATA[i].LPU,	HM_DATA[i].PODR,HM_DATA[i].CODE_USL,HM_DATA[i].KOL_USL,HM_DATA[i].DS,HM_DATA[i].UET_USL,HM_DATA[i].DATE_IN,HM_DATA[i].CODE_MD,HM_DATA[i].PRVD,HM_DATA[i].DET,HM_DATA[i].PRVS,HM_DATA[i].DATE_1,HM_DATA[i].DATE_2,HM_DATA[i].TARIF,HM_DATA[i].SUMV_USL,HM_DATA[i].PROFIL,HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,	
	foreach(line_zap; xml_zap) {
		xml_sluch = line_zap.parseXPath("//SLUCH");
		foreach(line_sluch; xml_sluch) {
			xml_usl = line_sluch.parseXPath("//USL");
			foreach(line_usl; xml_usl) {
				for (int i2=0; i2<line_zap.getChildren.length; i2++) {
					switch (line_zap.getChildren[i2].getName.toUpper){
						case "N_ZAP": HM_DATA[j].N_ZAP = line_zap.getChildren[i2].getCData.text; break;
						//case "PR_NOV": HM_DATA[j].PR_NOV = line_zap.getChildren[i2].getCData.text; break;
						case "PACIENT":
							for (int j2=0; j2<line_zap.getChildren[i2].getChildren.length; j2++) {
								switch (line_zap.getChildren[i2].getChildren[j2].getName.toUpper){
									case "ID_PAC": HM_DATA[j].ID_PAC = line_zap.getChildren[i2].getChildren[j2].getCData.text; break;
									//case "VPOLIS": HM_DATA[j].VPOLIS = line_zap.getChildren[i2].getChildren[j2].getCData.text; break;
									case "SPOLIS": HM_DATA[j].SPOLIS = line_zap.getChildren[i2].getChildren[j2].getCData.text; break;
									case "NPOLIS": HM_DATA[j].NPOLIS = line_zap.getChildren[i2].getChildren[j2].getCData.text; break;
									case "ST_OKATO": HM_DATA[j].ST_OKATO = line_zap.getChildren[i2].getChildren[j2].getCData.text; break;
									case "SMO": HM_DATA[j].SMO = line_zap.getChildren[i2].getChildren[j2].getCData.text; break;
									//case "SMO_OGRN": HM_DATA[j].SMO_OGRN = line_zap.getChildren[i2].getChildren[j2].getCData.text; break;
									//case "SMO_OK": HM_DATA[j].SMO_OK = line_zap.getChildren[i2].getChildren[j2].getCData.text; break;
									//case "SMO_NAM": HM_DATA[j].SMO_NAM = line_zap.getChildren[i2].getChildren[j2].getCData.text; break;
									case "NOVOR": HM_DATA[j].NOVOR = line_zap.getChildren[i2].getChildren[j2].getCData.text; break;
									default: break;
								}
							}
							break;
						case "SLUCH":
							for (int j2=0; j2<line_sluch.getChildren.length; j2++) {
								switch (line_sluch.getChildren[j2].getName.toUpper){
									case "IDCASE": HM_DATA[j].IDCASE = line_sluch.getChildren[j2].getCData.text; break;
									//case "USL_OK": HM_DATA[j].USL_OK = line_sluch.getChildren[j2].getCData.text; break;
									//case "VIDPOM": HM_DATA[j].VIDPOM = line_sluch.getChildren[j2].getCData.text; break;
									//case "FOR_POM": HM_DATA[j].FOR_POM = line_sluch.getChildren[j2].getCData.text; break;
									//case "NPR_MO": HM_DATA[j].NPR_MO = line_sluch.getChildren[j2].getCData.text; break;
									//case "EXTR": HM_DATA[j].EXTR = line_sluch.getChildren[j2].getCData.text; break;
									case "NHISTORY": HM_DATA[j].NHISTORY = line_sluch.getChildren[j2].getCData.text; break;
									case "DATE_1": HM_DATA[j].DATE_1 = line_sluch.getChildren[j2].getCData.text; break;
									case "DATE_2": HM_DATA[j].DATE_2 = line_sluch.getChildren[j2].getCData.text; break;
									//case "DS0": HM_DATA[j].DS0 = line_sluch.getChildren[j2].getCData.text; break;
									//case "DS1": HM_DATA[j].DS1 = line_sluch.getChildren[j2].getCData.text; break;
									//case "DS2": HM_DATA[j].DS2 = line_sluch.getChildren[j2].getCData.text; break;
									//case "CODE_MES1": HM_DATA[j].CODE_MES1 = line_sluch.getChildren[j2].getCData.text; break;
									//case "CODE_MES2": HM_DATA[j].CODE_MES2 = line_sluch.getChildren[j2].getCData.text; break;
									case "RSLT": HM_DATA[j].RSLT = line_sluch.getChildren[j2].getCData.text; break;
									//case "ISHOD": HM_DATA[j].ISHOD = line_sluch.getChildren[j2].getCData.text; break;
									//case "IDDOKT": HM_DATA[j].IDDOKT = line_sluch.getChildren[j2].getCData.text; break;
									//case "OS_SLUCH": HM_DATA[j].OS_SLUCH = line_sluch.getChildren[j2].getCData.text; break;
									//case "IDSP": HM_DATA[j].IDSP = line_sluch.getChildren[j2].getCData.text; break;
									//case "ED_COL": HM_DATA[j].ED_COL = line_sluch.getChildren[j2].getCData.text; break;
									//case "UET": HM_DATA[j].UET = line_sluch.getChildren[j2].getCData.text; break;
									//case "SUMV": HM_DATA[j].SUMV = line_sluch.getChildren[j2].getCData.text; break;
									//case "OPLATA": HM_DATA[j].OPLATA = line_sluch.getChildren[j2].getCData.text; break;
									case "USL":
										for (int j3=0; j3<line_usl.getChildren.length; j3++){
											switch (line_usl.getChildren[j3].getName.toUpper){
												
												case "IDSERV": HM_DATA[j].IDSERV = line_usl.getChildren[j3].getCData.text; break;
												case "LPU": HM_DATA[j].LPU = line_usl.getChildren[j3].getCData.text; break;
												//case "LPU1": HM_DATA[j].LPU1 = line_usl.getChildren[j3].getCData.text; break;
												case "PODR": HM_DATA[j].PODR = line_usl.getChildren[j3].getCData.text; break;
												case "PROFIL": HM_DATA[j].PROFIL = line_usl.getChildren[j3].getCData.text; break;
												case "DET": HM_DATA[j].DET = line_usl.getChildren[j3].getCData.text; break;
												case "DATE_IN": HM_DATA[j].DATE_IN = line_usl.getChildren[j3].getCData.text; break;
												//case "DATE_OUT": HM_DATA[j].DATE_OUT = line_usl.getChildren[j3].getCData.text; break;
												case "DS": HM_DATA[j].DS = line_usl.getChildren[j3].getCData.text; break;
												case "CODE_USL": HM_DATA[j].CODE_USL = line_usl.getChildren[j3].getCData.text; break;
												case "KOL_USL": HM_DATA[j].KOL_USL = line_usl.getChildren[j3].getCData.text; break;
												case "UET_USL": HM_DATA[j].UET_USL = line_usl.getChildren[j3].getCData.text; break;
												case "PRVD": HM_DATA[j].PRVD = line_usl.getChildren[j3].getCData.text; break;
												case "TARIF": HM_DATA[j].TARIF = line_usl.getChildren[j3].getCData.text; break;
												case "SUMV_USL": HM_DATA[j].SUMV_USL = line_usl.getChildren[j3].getCData.text; break;
												case "PRVS": HM_DATA[j].PRVS = line_usl.getChildren[j3].getCData.text; break;
												case "CODE_MD": HM_DATA[j].CODE_MD = (line_usl.getChildren[j3].getCData.text.length<3 ? line_usl.getChildren[j3].getCData.text : line_usl.getChildren[j3].getCData.text[0..3]); break;
												case "COMENTU": HM_DATA[j].COMENTU = line_usl.getChildren[j3].getCData.text; break;
												default: break;
											}
										}
										break;
									case "COMENTSL": HM_DATA[j].COMENTSL = line_sluch.getChildren[j2].getCData.text; break;
									default: break;
								}
							}
							break;
						//*/
						default:
						break;
					}
				}
				j++;
			}//USL
		}//SLUCH
		i++;
	}//ZAP
	//*/	
	// ФОРМАТНО-ЛОГИЧЕСКИЙ КОНТРОЛЬ (проверяем все значения созданных структур данных)
	// СОЗДАЕМ TXT ФАЙЛ ИЗ ДАННЫХ СТРУКТУРЫ, ПОДХОДЯЩИЙ ДЛЯ НАШЕГО СЕРВЕРА	
	auto RCLINUP = new RCLINUP1[](HM_DATA.length);
	bool flag1 = false;
	j = 0;
	string n_zap = ""; // <ZAP>
	string idcase = ""; // <SLUCH> может быть несколько в пределах одной записи <ZAP> и со своими отдельными <USL> 
	string idserv = ""; // <USL> несколько в пределах олного <SLUCH>
	string answer_str = "";
	string txt_file_str = "";
	//string stat_z = "";
	bool stop_txt = false;
	int q_ogrn = 0;
	
	auto f = File(xml_ctmp ~ args[5].toUpper, "w");
	auto f1 = File(xml_ctmp ~ FM_NAME_FLK, "w");
	auto f2 = File(xml_ctmp ~ VM_NAME_FLK, "w");
	f1.write("<?xml version=\"1.0\" encoding=\"Windows-1251\"?>\n<FLK_P>\n\t<FNAME>"~FM_NAME_FLK~"</FNAME>\n\t<FNAME_I>"~LM_NAME~"</FNAME_I>\n");
	f2.write("<?xml version=\"1.0\" encoding=\"Windows-1251\"?>\n<FLK_P>\n\t<FNAME>"~VM_NAME_FLK~"</FNAME>\n\t<FNAME_I>"~HM_NAME~"</FNAME_I>\n");
	for(i=0; i<HM_DATA.length; i++){
		// Связываемся с персональными данными
		if(LM_DATA[j].ID_PAC!=HM_DATA[i].ID_PAC){
			for(j=0;j<LM_DATA.length;j++){
				if (LM_DATA[j].ID_PAC==HM_DATA[i].ID_PAC) {flag1=false; break;}
				flag1=true;
			}
		}
		// stat_z
		//if(HM_DATA[i].NOVOR != "0"){stat_z = "1";}
		//if(HM_DATA[i].RSLT == "8" || HM_DATA[i].RSLT == "9"){stat_z = "0";}
		
		// Контекст ZAP
		if (n_zap != HM_DATA[i].N_ZAP){
			// Подключим s_strcomp
			//for(int jj=1; jj<s_strcomp.length; jj++){
				//if(HM_DATA[i].SMO.length != 5){
					//break;
				//}
				//if(s_strcomp[jj][countUntil(s_strcomp[0],"codstk")].toUpper==HM_DATA[i].SMO[$-3..$].toUpper){
					//q_ogrn = jj;
					//break;
				//}
			//}
			if(CHECK_VALUE(RCLINUP_DAT,"stnum",LM_DATA[j].SNILS,answer_str) != 0){stop_txt = true; f1.write(L_FLK_PRTKL("207","SNILS","PERS",HM_DATA[i].NHISTORY,LM_DATA[j].ID_PAC,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"family",LM_DATA[j].FAM,answer_str) != 0){stop_txt = true; f1.write(L_FLK_PRTKL("207","FAM","PERS",HM_DATA[i].NHISTORY,LM_DATA[j].ID_PAC,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"name",LM_DATA[j].IM,answer_str) != 0){stop_txt = true; f1.write(L_FLK_PRTKL("207","IM","PERS",HM_DATA[i].NHISTORY,LM_DATA[j].ID_PAC,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"name2",LM_DATA[j].OT,answer_str) != 0){stop_txt = true; f1.write(L_FLK_PRTKL("207","OT","PERS",HM_DATA[i].NHISTORY,LM_DATA[j].ID_PAC,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"dbirth",LM_DATA[j].DR,answer_str) != 0){stop_txt = true; f1.write(L_FLK_PRTKL("207","DR","PERS",HM_DATA[i].NHISTORY,LM_DATA[j].ID_PAC,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"sex",LM_DATA[j].W,answer_str) != 0){stop_txt = true; f1.write(L_FLK_PRTKL("207","W","PERS",HM_DATA[i].NHISTORY,LM_DATA[j].ID_PAC,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"c_doc",LM_DATA[j].DOCTYPE,answer_str) != 0){stop_txt = true; f1.write(L_FLK_PRTKL("207","DOCTYPE","PERS",HM_DATA[i].NHISTORY,LM_DATA[j].ID_PAC,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"s_doc",LM_DATA[j].DOCSER,answer_str) != 0){stop_txt = true; f1.write(L_FLK_PRTKL("207","DOCSER","PERS",HM_DATA[i].NHISTORY,LM_DATA[j].ID_PAC,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"n_doc",LM_DATA[j].DOCNUM,answer_str) != 0){stop_txt = true; f1.write(L_FLK_PRTKL("207","DOCNUM","PERS",HM_DATA[i].NHISTORY,LM_DATA[j].ID_PAC,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"parent",LM_DATA[j].FAM_P,answer_str) != 0){stop_txt = true; f1.write(L_FLK_PRTKL("207","FAM_P","PERS",HM_DATA[i].NHISTORY,LM_DATA[j].ID_PAC,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"parent",LM_DATA[j].IM_P,answer_str) != 0){stop_txt = true; f1.write(L_FLK_PRTKL("207","IM_P","PERS",HM_DATA[i].NHISTORY,LM_DATA[j].ID_PAC,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"parent",LM_DATA[j].OT_P,answer_str) != 0){stop_txt = true; f1.write(L_FLK_PRTKL("207","OT_P","PERS",HM_DATA[i].NHISTORY,LM_DATA[j].ID_PAC,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"n_zap",HM_DATA[i].N_ZAP,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","N_ZAP","ZAP",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"polisser",HM_DATA[i].SPOLIS,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","SPOLIS","PACIENT",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"polisn",HM_DATA[i].NPOLIS,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","NPOLIS","PACIENT",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"job_nam",HM_DATA[i].ST_OKATO,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","ST_OKATO","PACIENT",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}			
			// Это вспомогательное значение СМО. Передается в однотипное поле apart на сервере и затем стирается.
			if(CHECK_VALUE(RCLINUP_DAT,"apart",HM_DATA[i].SMO,answer_str /*,true т.е. проверять на null*/ ) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","SMO","PACIENT",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
		}
		// Контекст SLUCH
		if (idcase != HM_DATA[i].IDCASE){
			if(CHECK_VALUE(RCLINUP_DAT,"num",HM_DATA[i].NHISTORY,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","NHISTORY","SLUCH",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"date_e",HM_DATA[i].DATE_2,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","DATE_2","SLUCH",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"idcase",HM_DATA[i].IDCASE,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","IDCASE","SLUCH",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"d_listin",HM_DATA[i].DATE_1,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","DATE_1","SLUCH",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"d_listout",HM_DATA[i].DATE_2,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","DATE_2","SLUCH",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
			if(CHECK_VALUE(RCLINUP_DAT,"kodres",HM_DATA[i].RSLT,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","RSLT","SLUCH",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
		}
		// Контекст USL
		if(CHECK_VALUE(RCLINUP_DAT,"kodh",HM_DATA[i].LPU[HM_DATA[i].LPU.length-3..HM_DATA[i].LPU.length],answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","LPU","USL",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
		if(CHECK_VALUE(RCLINUP_DAT,"ko",HM_DATA[i].PODR,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","PODR","USL",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
		if(CHECK_VALUE(RCLINUP_DAT,"nys",HM_DATA[i].CODE_USL,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","CODE_USL","USL",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
		if(CHECK_VALUE(RCLINUP_DAT,"nkol",HM_DATA[i].KOL_USL,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","KOL_USL","USL",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
		if(CHECK_VALUE(RCLINUP_DAT,"key2",HM_DATA[i].DS,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","DS","USL",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
		if(CHECK_VALUE(RCLINUP_DAT,"uet",HM_DATA[i].UET_USL,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","UET_USL","USL",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
		if(CHECK_VALUE(RCLINUP_DAT,"date",HM_DATA[i].DATE_IN,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","DATE_IN","USL",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
		if(CHECK_VALUE(RCLINUP_DAT,"number1",HM_DATA[i].CODE_MD,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","CODE_MD","USL",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
		if(CHECK_VALUE(RCLINUP_DAT,"prvd",HM_DATA[i].PRVD,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","PRVD","USL",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
		if(CHECK_VALUE(RCLINUP_DAT,"d",HM_DATA[i].DET,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","DET","USL",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
		if(CHECK_VALUE(RCLINUP_DAT,"prvs",HM_DATA[i].PRVS,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","PRVS","USL",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
		if(CHECK_VALUE(RCLINUP_DAT,"cu",HM_DATA[i].TARIF,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","TARIF","USL",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
		if(CHECK_VALUE(RCLINUP_DAT,"sum",HM_DATA[i].SUMV_USL,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","SUMV_USL","USL",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
		if(CHECK_VALUE(RCLINUP_DAT,"PRMP",HM_DATA[i].PROFIL,answer_str) != 0){stop_txt = true; f2.write(H_FLK_PRTKL("207","PROFIL","USL",HM_DATA[i].N_ZAP,HM_DATA[i].IDCASE,HM_DATA[i].IDSERV,HM_DATA[i].NHISTORY,answer_str));}
		
		// Если не было ошибок, то продолжаем формировать txt файл реестра
		if(stop_txt == false){
			// Создаем txt файл реестра
			f.writeln(	HM_DATA[i].NHISTORY,"\t",
						LM_DATA[j].SNILS,"\t",
						(std.utf.count(LM_DATA[j].FAM)>20) ? LM_DATA[j].FAM[0..40] : LM_DATA[j].FAM,"\t",
						// LM_DATA[j].FAM,"\t",
						(std.utf.count(LM_DATA[j].IM)>15) ? LM_DATA[j].IM[0..30] : LM_DATA[j].IM,"\t",
						// LM_DATA[j].IM,"\t",
						(std.utf.count(LM_DATA[j].OT)>20) ? LM_DATA[j].OT[0..40] : LM_DATA[j].OT,"\t",
						// LM_DATA[j].OT,"\t",
						LM_DATA[j].DR,"\t",
						LM_DATA[j].W,"\t",
						(LM_DATA[j].DOCTYPE=="" ? "0" : LM_DATA[j].DOCTYPE),"\t",
						LM_DATA[j].DOCSER,"\t",
						LM_DATA[j].DOCNUM,"\t",
						"0","\t",
						HM_DATA[i].ST_OKATO,"\t", //Это поле job_nam я использую для передачи st_okato на сервер и затем, после некоторых действий, стираю.
						"\t",
						"\t",
						"\t",
						"\t",
						"\t",
						"\t", 
						HM_DATA[i].SMO.toUpper,"\t", // это поле apart в таблице rclinup1. Оно также 5 символов и не null. HM_DATA[i].SMO[$-3..$].toUpper,"\t",
						"\t",
						"38","\t", // это поле заполнить после приема txt через таблицу reestr_recept
						(HM_DATA[i].NOVOR != "0" ? "1":(HM_DATA[i].RSLT=="8" || HM_DATA[i].RSLT=="9" ? "0":"0")),"\t", // это stat_z
						// stat_z ~ "\t" ~
						"9","\t", // Признак, что этот реестр от МИАЦ (а так, пустое должно быть)
						// опираясь на этот признак
						LM_DATA[j].FAM_P ~ LM_DATA[j].IM_P ~ LM_DATA[j].OT_P,"\t",
						".00" ~ "\t" ~ // HM_DATA[i].SUMMV_USL
						HM_DATA[i].SPOLIS,"\t",
						HM_DATA[i].NPOLIS,"\t",
						"\t",
						HM_DATA[i].DATE_2,"\t",
						"\t", //s_strcomp[q_ogrn][countUntil(s_strcomp[0],"q_ogrn")],"\t",
						"\t", //s_strcomp[q_ogrn][countUntil(s_strcomp[0],"namestk")],"\t",
						HM_DATA[i].LPU[3..$],"\t",
						("  " ~ HM_DATA[i].PODR.strip)[$-2..$],"\t", // ko прижимаем вправо
						HM_DATA[i].CODE_USL,"\t", // nys прижимаем влево
						(HM_DATA[i].KOL_USL == "" ? "0" : HM_DATA[i].KOL_USL),"\t",
						HM_DATA[i].DS,"\t",
						(HM_DATA[i].UET_USL == "" ? "0" : HM_DATA[i].UET_USL),"\t",
						HM_DATA[i].DATE_IN,"\t",
						HM_DATA[i].CODE_MD,"\t", //HM_DATA[i].CODE_MD[0..3],"\t",
						"\t",
						"\t", // rslt условие
						(HM_DATA[i].PRVD=="" ? "0" : HM_DATA[i].PRVD),"\t",
						HM_DATA[i].DET,"\t",
						HM_DATA[i].PRVS,"\t",
						(HM_DATA[i].RSLT == "" ? "0" : HM_DATA[i].RSLT),"\t", //"0","\t",
						HM_DATA[i].DATE_1,"\t",
						HM_DATA[i].DATE_2,"\t",
						(HM_DATA[i].TARIF == "" ? "0" : HM_DATA[i].TARIF),"\t",
						(HM_DATA[i].SUMV_USL == "" ? "0" : HM_DATA[i].SUMV_USL),"\t",
						"\t", //s_strcomp[q_ogrn][countUntil(s_strcomp[0],"kodab")].strip,"\t",
						(HM_DATA[i].COMENTU == "1" ? "1" : (HM_DATA[i].COMENTU > "2" ? "2" : "0")),"\t", //"0","\t",
						(HM_DATA[i].PROFIL == "" ? "0" : HM_DATA[i].PROFIL),"\t",
						HM_DATA[i].N_ZAP,"\t",
						HM_DATA[i].IDCASE,"\t",
						"\t",
						"\t",
						"\t",
						"\t",
						"\t",
						"\t",
						"\t",
						"\t",
						"\t",
						"\t",
						"\t",
						HM_DATA[i].IDSERV
					);
		}
		//stat_z = "0";
		//----------------------
		n_zap = HM_DATA[i].N_ZAP; // <ZAP>
		idcase = HM_DATA[i].IDCASE; // <SLUCH>
		idserv = HM_DATA[i].IDSERV; // <USL>
	}
	//*/
	f.close();
	f1.write("</FLK_P>");
	f2.write("</FLK_P>");
	f1.close();
	f2.close();
	std.file.write(xml_ctmp ~ FM_NAME_FLK,UTF8_CP1251(readText(xml_ctmp ~ FM_NAME_FLK)));
	std.file.write(xml_ctmp ~ VM_NAME_FLK,UTF8_CP1251(readText(xml_ctmp ~ VM_NAME_FLK)));
	string shell_command = "";
	// Создадим архив ФЛК
	shell_command = "\"E:/DBF_Files/galmel/bat/7z/7za.exe\" a -tzip  -ssw -mx7 "~ xml_cflk ~ VM_NAME_FLK[0..$-4] ~ ".zip " ~ xml_ctmp ~ FM_NAME_FLK ~ " " ~ xml_ctmp ~ VM_NAME_FLK;
	auto cmd1 = executeShell(shell_command);
	if (cmd1.status != 0){writeln("Failed to execute 7z"); return 1;} //else writeln(cmd1.output);
	// Если не было ФЛК ошибок, то создадим архив с txt реестром
	if(stop_txt == false){
		std.file.write(xml_ctmp ~ args[5].toUpper,UTF8_CP1251(readText(xml_ctmp ~ args[5].toUpper)));
		shell_command = "\"E:/DBF_Files/galmel/bat/7z/7za.exe\" a -tzip  -ssw -mx7 "~ xml_clinic ~ args[5].toUpper[0..$-4] ~ ".rar " ~ xml_ctmp ~ args[5].toUpper ~ " " ~ args[2].toUpper;
		auto cmd2 = executeShell(shell_command);
		if (cmd2.status != 0){writeln("Failed to execute 7z"); return 1;}//else writeln(cmd2.output);		
	}
	writeln(sw.peek().msecs);
	return 0;
}
