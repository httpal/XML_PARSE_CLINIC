module funcs;
import std.stdio;
import std.file;
import std.string;
import std.encoding;
import std.conv;
import std.algorithm;
import std.array;
import std.utf;
import std.uni;

// Для функций перекодирования
int[] utf32codes_cp1251idx =  [0x0000,0x0001,0x0002,0x0003,0x0004,0x0005,0x0006,0x0007,0x0008,0x0009,0x000A,0x000B,0x000C,0x000D,0x000E,0x000F,0x0010,0x0011,0x0012,0x0013,0x0014,0x0015,0x0016,0x0017,0x0018,0x0019,0x001A,0x001B,0x001C,0x001D,0x001E,0x001F,0x0020,0x0021,0x0022,0x0023,0x0024,0x0025,0x0026,0x0027,0x0028,0x0029,0x002A,0x002B,0x002C,0x002D,0x002E,0x002F,0x0030,0x0031,0x0032,0x0033,0x0034,0x0035,0x0036,0x0037,0x0038,0x0039,0x003A,0x003B,0x003C,0x003D,0x003E,0x003F,0x0040,0x0041,0x0042,0x0043,0x0044,0x0045,0x0046,0x0047,0x0048,0x0049,0x004A,0x004B,0x004C,0x004D,0x004E,0x004F,0x0050,0x0051,0x0052,0x0053,0x0054,0x0055,0x0056,0x0057,0x0058,0x0059,0x005A,0x005B,0x005C,0x005D,0x005E,0x005F,0x0060,0x0061,0x0062,0x0063,0x0064,0x0065,0x0066,0x0067,0x0068,0x0069,0x006A,0x006B,0x006C,0x006D,0x006E,0x006F,0x0070,0x0071,0x0072,0x0073,0x0074,0x0075,0x0076,0x0077,0x0078,0x0079,0x007A,0x007B,0x007C,0x007D,0x007E,0x007F,0x0402,0x0403,0x201A,0x0453,0x201E,0x2026,0x2020,0x2021,0x20AC,0x2030,0x0409,0x2039,0x040A,0x040C,0x040B,0x040F,0x0452,0x2018,0x2019,0x201C,0x201D,0x2022,0x2013,0x2014,0x0000,0x2122,0x0459,0x203A,0x045A,0x045C,0x045B,0x045F,0x00A0,0x040E,0x045E,0x0408,0x00A4,0x0490,0x00A6,0x00A7,0x0401,0x00A9,0x0404,0x00AB,0x00AC,0x00AD,0x00AE,0x0407,0x00B0,0x00B1,0x0406,0x0456,0x0491,0x00B5,0x00B6,0x00B7,0x0451,0x2116,0x0454,0x00BB,0x0458,0x0405,0x0455,0x0457,0x0410,0x0411,0x0412,0x0413,0x0414,0x0415,0x0416,0x0417,0x0418,0x0419,0x041A,0x041B,0x041C,0x041D,0x041E,0x041F,0x0420,0x0421,0x0422,0x0423,0x0424,0x0425,0x0426,0x0427,0x0428,0x0429,0x042A,0x042B,0x042C,0x042D,0x042E,0x042F,0x0430,0x0431,0x0432,0x0433,0x0434,0x0435,0x0436,0x0437,0x0438,0x0439,0x043A,0x043B,0x043C,0x043D,0x043E,0x043F,0x0440,0x0441,0x0442,0x0443,0x0444,0x0445,0x0446,0x0447,0x0448,0x0449,0x044A,0x044B,0x044C,0x044D,0x044E,0x044F];
int[] utf32codes_cp866idx  =  [0x0000,0x0001,0x0002,0x0003,0x0004,0x0005,0x0006,0x0007,0x0008,0x0009,0x000A,0x000B,0x000C,0x000D,0x000E,0x000F,0x0010,0x0011,0x0012,0x0013,0x0014,0x0015,0x0016,0x0017,0x0018,0x0019,0x001A,0x001B,0x001C,0x001D,0x001E,0x001F,0x0020,0x0021,0x0022,0x0023,0x0024,0x0025,0x0026,0x0027,0x0028,0x0029,0x002A,0x002B,0x002C,0x002D,0x002E,0x002F,0x0030,0x0031,0x0032,0x0033,0x0034,0x0035,0x0036,0x0037,0x0038,0x0039,0x003A,0x003B,0x003C,0x003D,0x003E,0x003F,0x0040,0x0041,0x0042,0x0043,0x0044,0x0045,0x0046,0x0047,0x0048,0x0049,0x004A,0x004B,0x004C,0x004D,0x004E,0x004F,0x0050,0x0051,0x0052,0x0053,0x0054,0x0055,0x0056,0x0057,0x0058,0x0059,0x005A,0x005B,0x005C,0x005D,0x005E,0x005F,0x0060,0x0061,0x0062,0x0063,0x0064,0x0065,0x0066,0x0067,0x0068,0x0069,0x006A,0x006B,0x006C,0x006D,0x006E,0x006F,0x0070,0x0071,0x0072,0x0073,0x0074,0x0075,0x0076,0x0077,0x0078,0x0079,0x007A,0x007B,0x007C,0x007D,0x007E,0x007F,0x0410,0x0411,0x0412,0x0413,0x0414,0x0415,0x0416,0x0417,0x0418,0x0419,0x041a,0x041b,0x041c,0x041d,0x041e,0x041f,0x0420,0x0421,0x0422,0x0423,0x0424,0x0425,0x0426,0x0427,0x0428,0x0429,0x042a,0x042b,0x042c,0x042d,0x042e,0x042f,0x0430,0x0431,0x0432,0x0433,0x0434,0x0435,0x0436,0x0437,0x0438,0x0439,0x043a,0x043b,0x043c,0x043d,0x043e,0x043f,0x2591,0x2592,0x2593,0x2502,0x2524,0x2561,0x2562,0x2556,0x2555,0x2563,0x2551,0x2557,0x255d,0x255c,0x255b,0x2510,0x2514,0x2534,0x252c,0x251c,0x2500,0x253c,0x255e,0x255f,0x255a,0x2554,0x2569,0x2566,0x2560,0x2550,0x256c,0x2567,0x2568,0x2564,0x2565,0x2559,0x2558,0x2552,0x2553,0x256b,0x256a,0x2518,0x250c,0x2588,0x2584,0x258c,0x2590,0x2580,0x0440,0x0441,0x0442,0x0443,0x0444,0x0445,0x0446,0x0447,0x0448,0x0449,0x044a,0x044b,0x044c,0x044d,0x044e,0x044f,0x0401,0x0451,0x0404,0x0454,0x0407,0x0457,0x040e,0x045e,0x00b0,0x2219,0x00b7,0x221a,0x2116,0x00a4,0x25a0,0x00a0];

//---------------------------------------------------------------------------------------------
string[][] TBLTXT_ARRAY(string tbl_str){
	//Получим количество столбцов и строк из файла структуры
	int n_column = 0;
	int n_row = 0;
	foreach(line; tbl_str.splitLines()) {
		if (n_row == 0) {
			n_column = cast(int)count(line, "\t") + 1;
			}
		n_row++;
		}
	auto table_array = new string[][](3000,n_column);
	//writeln(table_array[0]);
	n_column = 0;
	n_row = 0;
	foreach(line; tbl_str.splitLines()) {
		n_column = 0;
		while (std.string.indexOf(line, "\t")!=-1) {
			table_array[n_row][n_column] = line[0 .. std.string.indexOf(line, "\t")];
			line = line[std.string.indexOf(line, "\t")+1 .. line.length];
			n_column++;
			}
		table_array[n_row][n_column] = line[0 .. line.length];
		n_row++;
		}
	return table_array[0..n_row];
}
//---------------------------------------------------------------------------------------------
int CHECK_VALUE(ref string[15][] array_struct,string NAME_FLD,string value, ref string answer_str, bool check_null = false){
	// Найдем тип поля в массиве array_struct
	int n_column = -1;
	for(int i=0; array_struct.length; i++){
		// toUpper и toLower работают медленно, поэтому используем функцию,
		// которая сравнивает строки без учета регистра sicmp или icmp(точнее работает с разными языками, но и медленнее)
		//if (array_struct[i][2].toUpper == NAME_FLD.toUpper) {
		//if (array_struct[i][2].toLower == NAME_FLD.toLower) {
		if (sicmp(array_struct[i][2],NAME_FLD) == 0) {
			n_column = i;
			break;
		}
	}
	int field_name = 2; // Индекс поля массива со структурой - тип
	int field_type = 3; // Индекс поля массива со структурой - тип
	int field_null = 4; // Индекс поля массива со структурой - null 
	int field_length = 5; // Индекс поля массива со структурой - величина поля
	int field_drobn = 7; // Индекс поля массива со структурой - дробная часть поля	
	int count_dots = 0; // Количество точек в дробных числах
	int txt_numeric_length = 0; // Длинна по факту числового поля в текстовом файле
	int sql_numeric_length = 0; // Длинна по факту числового поля на sql сервере

	//------------------------------- Дата ---------------------------------
	// SQL server принимает несколько вариантов даты. Например:
	// yyyy.dd.mm, yyyy-mm-dd, dd/mm/yyyy, dd.mm.yyyy ...
	// В этой программе я проверяю только на: dd.mm.yyyy.
	// Если попадется другой тип даты, то будет ошибка.
	if (strip(array_struct[n_column][field_type]) == "datetime" ||
		strip(array_struct[n_column][field_type]) == "smalldatetime") {
		// Очистим от пробелов
		value = value.strip;
		// Проверим на null
		if (strip(array_struct[n_column][field_null]) == "no" && value == "") {
			answer_str = "Недопустимое пустое значение: '" ~ value ~ "'";
			return 30;
			}
		
		if (value.length > 0) {
			// Проверим длинну
			if (value.length != 10) {
				answer_str = "Недопустимое значение даты: '" ~ value ~ "'";
				return 30;
				}
			// Проверим расположение точек - разделителей
			if  ((value[2]!='.' || value[5]!='.') && (value[2]!='-' || value[5]!='-') && 
				(value[4]!='-' || value[7]!='-') && (value[4]!='.' || value[7]!='.') && 
				(value[4]!='/' || value[7]!='/')){
				answer_str = "Недопустимое значение даты: '" ~ value ~ "'";
				return 30;
				}
			// Убедившись, что value - это триада дниной из 10 символов вида: 
			// yyyy.dd.mm, yyyy-mm-dd, dd/mm/yyyy, dd.mm.yyyy ...,
			// преобразуем значение value к единому виду для быстрой проверки.
			if ((value[4]=='-' && value[7]=='-') || (value[4]=='.' && value[7]=='.') ||
				(value[4]=='/' && value[7]=='/')) {
				value = value[8..value.length] ~ "." ~ value[5..7] ~ "." ~ value[0..4];
			}
			// Проверим каждый блок даты: день, месяц, год (dd.mm.yyyy)
			if (indexOf(['0','1','2','3'],value[0]) == -1 || indexOf(['0','1','2','3','4','5','6','7','8','9'],value[1]) == -1 ||
				indexOf(['0','1'],value[3]) == -1 || indexOf(['0','1','2','3','4','5','6','7','8','9'],value[4]) == -1 ||
				indexOf(['1','2'],value[6]) == -1 || indexOf(['0','9'],value[7]) == -1 ||
				indexOf(['0','1','2','3','4','5','6','7','8','9'],value[8]) == -1 || indexOf(['0','1','2','3','4','5','6','7','8','9'],value[7]) == -1) {
				answer_str = "Недопустимое значение даты: '" ~ value ~ "'";
				return 30;
				}
			// Проверим max и min кол-во дней (31)
			if (to!int(value[0..2])<1 || to!int(value[0..2])>31) {
				answer_str = "Недопустимое значение даты: '" ~ value ~ "'";
				return 30;
				}
			// Проверим max и min кол-во месяцев (12)
			if (to!int(value[3..5])<1 || to!int(value[3..5])>12) {
				answer_str = "Недопустимое значение даты: '" ~ value ~ "'";
				return 30;
				}
			// Проверим max и min кол-во лет (1800 - 2100)
			if (to!int(value[6..10])<1899 || to!int(value[6..10])>2100) {
				answer_str = "Недопустимое значение даты: '" ~ value ~ "'";
				return 30;
				}
			}
		}

	//------------------------------- Логический тип поля --------------------------------------
	if (strip(array_struct[n_column][field_type]) == "bit") {
		// Очистим пробелы слева, если они есть
		value = value.strip;
		// Проверим на null
		if (strip(array_struct[n_column][field_null]) == "no" && value == "") {
			answer_str = "Недопустимое пустое значение: '" ~ value ~ "'";
			return 30;
			}
		if (value.length > 0) {
			// Проверим на пробелы после логического значения
			for (int ii = 0; ii<value.length; ii++) {
				if (value[ii]==' ') {
					answer_str = "Недопустимое логическое значение: '" ~ value ~ "'";
					return 30;
					}
				}
			// Проверим длинну
			if (value.length > 1) {
				answer_str = "Недопустимое логическое значение: '" ~ value ~ "'";
				return 30;
				}
			// Проверим на допустимые значения
			if (indexOf(['0','1'],value)==-1) {
				answer_str = "Недопустимое логическое значение: '" ~ value ~ "'";
				return 30;
				}
			}
		}
	//-------------------------------- Строковые данные ----------------------------------------
	if (strip(array_struct[n_column][field_type]) == "char" || 
					strip(array_struct[n_column][field_type]) == "nchar" || 
					strip(array_struct[n_column][field_type]) == "varchar" || 
					strip(array_struct[n_column][field_type]) == "nvarchar") {
		// Проверим на null
		if (check_null == true && strip(array_struct[n_column][field_null]) == "no" && value == "") {
			answer_str = "Недопустимое пустое значение: '" ~ value ~ "'";
			return 30;
		}
		if (std.utf.count(value.strip) > 0) {
			if (std.utf.count(value.strip) > std.conv.to!int(array_struct[n_column][field_length])) {
				answer_str = "В значении '" ~ value ~ "' превышено допустимое количество символов (max: " ~ array_struct[n_column][field_length] ~ ")";
				return 30;
				}
			}
		}
	if (strip(array_struct[n_column][field_type]) == "text" ||
				strip(array_struct[n_column][field_type]) == "ntext") {
		// А вот типы TEXT и NTEXT не принимают пустых знгачений при не NULLABLE.
		// Проверим на null
		if (strip(array_struct[n_column][field_null]) == "no" && value == "") {
			answer_str = "Недопустимое пустое значение: '" ~ value ~ "'";
			return 30;
			}
		// Длина полей TEXT и NTEXT фиксированная, и они гораздо длиннее чем типы *CHAR. 
		// Длина TEXT = 2 147 483 647(не юникод), NTEXT = 1 073 741 823(юникод). Это оооооочень много, пока не проверяю...
		}
	//------------------------------------ Числа ----------------------------------------------
	if (strip(array_struct[n_column][field_type]) == "int" ||
				strip(array_struct[n_column][field_type]) == "bigint" ||
				strip(array_struct[n_column][field_type]) == "numeric" ||
				strip(array_struct[n_column][field_type]) == "decimal") {
		// Очистим от пробелов
		value = value.strip;
		// Проверим на null
		if (check_null == true && strip(array_struct[n_column][field_null]) == "no" && value == "") {
			answer_str = "Недопустимое пустое значение: '" ~ value ~ "'";
			return 30;
			}
		if (value.length > 0) {
			// Может быть число и с минусом. Для того, чтобы его проверить так же как и положительные числа,
			// обрежем этот минус, если он есть, и пойдем дальше проверять. как будто это положительное число.
			// Если встретиться еще один минус, то это уже будет ошибкой.
			if (value[0] == '-') {
				value = value[1..value.length];
				}
			// Если это значение просто точка
			if (value == ".") {
				answer_str = "Недопустимое значение числа: '" ~ value ~ "'";
				return 30;
				}
			// Определим, число ли это вообще
			for (int ii = 0; ii<value.length; ii++) {
				if (value[ii]=='.') {							
					count_dots++;
					}
				if (find(['.','0','1','2','3','4','5','6','7','8','9'],value[ii]) == [] || count_dots > 1) {
					answer_str = "Недопустимое значение числа: '" ~ value ~ "'";
					return 30;
					}
				}
			// Если точка стоит в начале или в конце
			if (value[0]=='.') { // если в начале
				value = "0" ~ value;
				}
			if (value[value.length-1]=='.') { // если в конце
				value = value[0..value.length-1];
				}
			// Если число с дробной частью а тип поля на сервере без дробной, то выдадим ошибку
			if ((strip(array_struct[n_column][field_drobn]) == "" || strip(array_struct[n_column][field_drobn]) == "0") &&
					indexOf(value, ".")!= -1) {
				answer_str = "Число должно быть без дробной части: '" ~ value ~ "'";
				return 30;
				}
			// Проверим длинну после определения числа: дробное или целое
			// Вычислим длинну числовой записи и длинну поля sql таблицы (т.к. при наличии дробной части, основная уменьшается)
			if (indexOf(value, ".") == -1) {txt_numeric_length = value.length; }
				else {txt_numeric_length = indexOf(value, ".");}
			// Если число вида "03434345" или "02.987", с нулем вначеле, то выдаем ошибку.
			if (value[0] == '0' && txt_numeric_length > 1) {
				// Проверим, если все нули, то пропустим
				for (int ii = 0; ii<value.length; ii++) {
					if (value[ii]!='0') {
						answer_str = "Недопустимое значение числа: '" ~ value ~ "'";
						return 30;
						}
					}
				}
			// Длинна поля на SQL
			if (std.conv.to!int(cast(string)strip(array_struct[n_column][field_drobn])) == 0) {
				sql_numeric_length = std.conv.to!int(cast(string)strip(array_struct[n_column][field_length]));				
				}
			else {
				sql_numeric_length = std.conv.to!int(cast(string)strip(array_struct[n_column][field_length]))-std.conv.to!int(cast(string)strip(array_struct[n_column][field_drobn]));
				}
			// Если, напеример на сервере целая часть числа задана 1 и дробная часть числа задана 1 или 2 к 2 или 3 к 3, то
			// это дробное число обязательно должно быть вида "0.дробная_часть". Т.е. в данном случае 0 - всегда целая часть числа в txt.
			if (sql_numeric_length == 0 && value[0] != '0') {
				answer_str = "Число '" ~ value ~ "' не соответствует заданному типу на сервере";
				return 30;
				}
			// Сравним длинну значения из txt файла с длинной из структуры sql
			//if (txt_numeric_length > sql_numeric_length && sql_numeric_length > 0) {
			if (txt_numeric_length > sql_numeric_length && sql_numeric_length > 0) {
				answer_str = "В значении '" ~ value ~ "' превышено допустимое количество символов (max: " ~ array_struct[n_column][field_length] ~ ")";
				return 30;
				}
			}
		}
	return 0;
}
//---------------------------------------------------------------------------------------------
// Эта функция подобна трем функциям для работы со строками strip, stripLeft, stripRight
int strip_ubyte(ref ubyte[] ubyte_str, int strip_123) {
	
	//-------- Пороверим, не все ли символы пробелы, если все, то удаляем их
	bool flag1 = false;
	for (int i = 0; i<ubyte_str.length; i++) {
		if (ubyte_str[i]!=32) {
			flag1 = true;
			}
		}
	if (flag1 == false) {
		ubyte_str = replace(ubyte_str, [32], cast(ubyte[])[]);
		}
	//--------------------------------------------------------
	
	if (ubyte_str == []) {
		return 1;
		}
	if ((strip_123 == 1 || strip_123 == 3) && ubyte_str != []) {
		while (cast(int)ubyte_str[0] == 32) {
			ubyte_str.replaceInPlace(0, 1, cast(ubyte[])[]);
			}
		}
	if ((strip_123 == 2 || strip_123 == 3) && ubyte_str != []) {
		while (cast(int)ubyte_str[ubyte_str.length-1] == 32) {
			ubyte_str.replaceInPlace(ubyte_str.length-1, ubyte_str.length, cast(ubyte[])[]);
			}
		}
	return 0;
	}

//---------------------------------------------------------------------------------------------
// В этой функции очищаем все неправильные переносы строк в цикле
int clear_wrong_enter(ref ubyte[] ubyte_str) {
	bool flag1 = false;
	bool flag2 = false;
	bool flag3 = false;
	bool flag4 = false;
	bool flag5 = false;
	bool flag6 = false;
	bool flag7 = false;
	while (flag1 != true || flag2 != true || flag3 != true || flag4 != true || flag5 != true || flag6 != true || flag7 != true) {
		if (find(ubyte_str,[13,13]) != []) {
			ubyte_str = replace(ubyte_str, cast(ubyte[])[13,13], cast(ubyte[])[13]);
			}
		else {flag1 = true;}
		
		if (find(ubyte_str,[10,10]) != []) {
			ubyte_str = replace(ubyte_str, cast(ubyte[])[10,10], cast(ubyte[])[10]);
			}
		else {flag2 = true;}
		
		if (find(ubyte_str,[13,10,13,10]) != []) {
			ubyte_str = replace(ubyte_str, cast(ubyte[])[13,10,13,10], cast(ubyte[])[13,10]);
			}
		else {flag3 = true;}
		
		if (find(ubyte_str,[10,13,10,13]) != []) {
			ubyte_str = replace(ubyte_str, cast(ubyte[])[10,13,10,13], cast(ubyte[])[13,10]);
			}
		else {flag4 = true;}
		
		if (find(ubyte_str,[13,10,13]) != []) {
			ubyte_str = replace(ubyte_str, cast(ubyte[])[13,10,13], cast(ubyte[])[13,10]);
			}
		else {flag5 = true;}
		
		if (find(ubyte_str,[10,13,10]) != []) {
			ubyte_str = replace(ubyte_str, cast(ubyte[])[10,13,10], cast(ubyte[])[13,10]);
			}
		else {flag6 = true;}
		
		if (find(ubyte_str,[10,13]) != []) {
			ubyte_str = replace(ubyte_str, cast(ubyte[])[10,13], cast(ubyte[])[13,10]);
			}
		else {flag7 = true;}
		}
	return 0;
	}
//---------------------------------------------------------------------------------------------
string CP1251_UTF8(string string_par, bool bom) {
	if (string_par.empty) {return "";}
	ubyte[] cp1251_ubyte_array = cast(ubyte[])string_par;
	auto utf_dchar_array = new dchar[](cp1251_ubyte_array.length);
	for (int i=0; i<cp1251_ubyte_array.length; i++) {
			utf_dchar_array[i] = cast(dchar)utf32codes_cp1251idx[cp1251_ubyte_array[i]];
		}
	if (bom == true) {return cast(string)cast(ubyte[])[239,187,191] ~ to!string(utf_dchar_array);} // UTF-8
		else {return to!string(utf_dchar_array);} // UTF-8(без BOM)
}
//---------------------------------------------------------------------------------------------
string UBYTE_UTF8(void[] string_par, bool bom) {
	if (string_par.empty) {return "";}
	ubyte[] cp1251_ubyte_array = cast(ubyte[])string_par;
	auto utf_dchar_array = new dchar[](cp1251_ubyte_array.length);
	for (int i=0; i<cp1251_ubyte_array.length; i++) {
			utf_dchar_array[i] = cast(dchar)utf32codes_cp1251idx[cp1251_ubyte_array[i]];
		}
	if (bom == true) {return cast(string)cast(ubyte[])[239,187,191] ~ to!string(utf_dchar_array);} // UTF-8
		else {return to!string(utf_dchar_array);} // UTF-8(без BOM)
}
//---------------------------------------------------------------------------------------------
string CP866_UTF8(string string_par, bool bom) {
	if (string_par.empty) {return "";}
	ubyte[] cp866_ubyte_array = cast(ubyte[])string_par;
	auto utf_dchar_array = new dchar[](cp866_ubyte_array.length);
	for (int i=0; i<cp866_ubyte_array.length; i++) {
			utf_dchar_array[i] = cast(dchar)utf32codes_cp866idx[cp866_ubyte_array[i]];
		}
	if (bom == true) {return cast(string)cast(ubyte[])[239,187,191] ~ to!string(utf_dchar_array);} // UTF-8
		else {return to!string(utf_dchar_array);} // UTF-8(без BOM)
}
//---------------------------------------------------------------------------------------------

string UTF8_CP1251(string string_par) {
	if (string_par.empty) {return "";}
	int[] utf_int_array = cast(int[])std.utf.toUTF32(string_par);	
	// Удалим BOM символ, если он есть
	if (utf_int_array[0] == 65279) {
		utf_int_array.replaceInPlace(0, 1, cast(int[])[]);
	}
	auto cp1252_codes = new int[](100000);
 	for (int i=0; i<utf32codes_cp1251idx.length; i++) {
		cp1252_codes[utf32codes_cp1251idx[i]] = i;
	}
	auto cp1251_ubyte_array = new ubyte[](utf_int_array.length);	
	for (int i=0; i<utf_int_array.length; i++) {
		cp1251_ubyte_array[i] = cast(ubyte)cp1252_codes[utf_int_array[i]];
		}
	return cast(string)cp1251_ubyte_array;
	}
//---------------------------------------------------------------------------------------------
string UTF8_CP866(string string_par) {
	if (string_par.empty) {return "";}
	int[] utf_int_array = cast(int[])std.utf.toUTF32(string_par);	
	// Удалим BOM символ, если он есть
	if (utf_int_array[0] == 65279) {
		utf_int_array.replaceInPlace(0, 1, cast(int[])[]);
	}
	auto cp866_codes = new int[](100000);
 	for (int i=0; i<utf32codes_cp866idx.length; i++) {
		cp866_codes[utf32codes_cp866idx[i]] = i;
	}
	auto cp866_ubyte_array = new ubyte[](utf_int_array.length);	
	for (int i=0; i<utf_int_array.length; i++) {
		cp866_ubyte_array[i] = cast(ubyte)cp866_codes[utf_int_array[i]];
		}
	return cast(string)cp866_ubyte_array;
	}
//---------------------------------------------------------------------------------------------

string CP1251_CP866(string string_par) {
	if (string_par.empty) {return "";}
	ubyte[] cp1251_ubyte_array = cast(ubyte[])string_par;
	auto CP866codes_cp1251idx = new int[](256);
 	
 	for (int i=0; i<utf32codes_cp1251idx.length; i++) {
		CP866codes_cp1251idx[i] = std.algorithm.countUntil(utf32codes_cp866idx, utf32codes_cp1251idx[i]);
	}
	auto cp866_ubyte_array = new ubyte[](cp1251_ubyte_array.length);	
	for (int i=0; i<cp1251_ubyte_array.length; i++) {
		cp866_ubyte_array[i] = cast(ubyte)CP866codes_cp1251idx[cp1251_ubyte_array[i]];
		}
	return cast(string)cp866_ubyte_array;
}
//---------------------------------------------------------------------------------------------

string CP866_CP1251(string string_par) {
	if (string_par.empty) {return "";}
	ubyte[] cp866_ubyte_array = cast(ubyte[])string_par;	
	auto CP1251codes_cp866idx = new int[](256);
 	
 	for (int i=0; i<utf32codes_cp866idx.length; i++) {
		CP1251codes_cp866idx[i] = std.algorithm.countUntil(utf32codes_cp1251idx, utf32codes_cp866idx[i]);
	}
	auto cp1251_ubyte_array = new ubyte[](cp866_ubyte_array.length);	
	for (int i=0; i<cp866_ubyte_array.length; i++) {
		cp1251_ubyte_array[i] = cast(ubyte)CP1251codes_cp866idx[cp866_ubyte_array[i]];
		}
	return cast(string)cp1251_ubyte_array;
}
//---------------------------------------------------------------------------------------------
string generate_answer(string type_, int n_row, int n_column, string len_val_null) {
	auto number_str_fld = "__err_value   s" ~ std.conv.to!string(n_row+1) ~ ":f" ~ std.conv.to!string(n_column+1) ~ " ";
	if (len_val_null=="value" || len_val_null=="length") {
		auto error_len_val = "invalid "~type_~" "~len_val_null~" ";
		return number_str_fld ~ error_len_val;
		}
	else {
		auto error_null = "type "~type_~" is not nullable ";
		return number_str_fld ~ error_null;
		}
	}
//---------------------------------------------------------------------------------------------
string[15][] GET_STRUCT_FROMDAT(string fl_struct_str){
	//Получим количество столбцов и строк из файла структуры
	int n_column = 0;
	int n_row = 0;
	foreach(line; fl_struct_str.splitLines()) {
		if (n_row == 0) {
			n_column = cast(int)count(line, "\t") + 1;
			}
		n_row++;
		}
	int kol_fields_sql = n_row;

	//array_struct[номер_столбца][номер_строки]
	enum column_const = 15;	
	auto array_struct = new string[column_const][kol_fields_sql];

	// Преобразуем текст в массив данных
	n_column = 0;
	n_row = 0; 
	foreach(line; fl_struct_str.splitLines()) {
		// В цикле заполняем элементы массива array_struct строками из file_str
		n_column = 0;
		while (std.string.indexOf(line, "\t")!=-1) {
			array_struct[n_row][n_column] = line[0 .. std.string.indexOf(line, "\t")];
			line = line[std.string.indexOf(line, "\t")+1 .. line.length];
			n_column++;
			}
		array_struct[n_row][n_column] = line[0 .. line.length];
		n_row++;
		}
	return array_struct;
}
//---------------------------------------------------------------------------------------------

// Функция проверки текстовых файлов с помощью полученной структуры SQL сервера
int check_file(ref ubyte[] ubyte_str,string fl_struct_str,ref string answer_str,ref int return_value,string special_case, string var4special_case) {
	// ubyte_str - это проверяемый файл открытый побайтово
	// fl_struct_str - это файл структуры таблицы на сервере, открытый символьной строкой. Этой структурой нужно проверить открытый файл ubyte_str.
	// answer_str - это строка ответа вызывающей программе. Туда пишеться ошибка для представления на сервере.
	// return_value - номер ошибки (после обработки ubyte_str) для вызывающей программы.
	// special_case - частный случай. Напимер один частный случай: |1| или несколько: |1|2|5|9|10|
	// var4special_case - этот папаметр вспомогательный, он служит для передачи доп инф для частногшо случая. Например, 
	// для частного случая |1| можно передать имя файла: |1 имя_файла 1| .Вспомогательных данных может быть несколько для нескольких частных случаев,
	// например: |1 имя_файла 1|2 для_2-го_частного_случая 2|10 для_10-го 10|254 для_254-го 254|
	
	//Получим количество столбцов и строк из файла структуры
	int n_column = 0;
	int n_row = 0;
	foreach(line; fl_struct_str.splitLines()) {
		if (n_row == 0) {
			n_column = cast(int)count(line, "\t") + 1;
			}
		n_row++;
		}
	int kol_fields_sql = n_row;
	

	//array_struct[номер_столбца][номер_строки]
	enum column_const = 15;	
	auto array_struct = new string[column_const][kol_fields_sql];

	// Преобразуем текст в массив данных
	n_column = 0;
	n_row = 0; 
	foreach(line; fl_struct_str.splitLines()) {
		// В цикле заполняем элементы массива array_struct строками из file_str
		n_column = 0;
		while (std.string.indexOf(line, "\t")!=-1) {
			array_struct[n_row][n_column] = line[0 .. std.string.indexOf(line, "\t")];
			line = line[std.string.indexOf(line, "\t")+1 .. line.length];
			n_column++;
			}
		array_struct[n_row][n_column] = line[0 .. line.length];
		n_row++;
		}

	// Посчитаем количество табов в txt
	bool byte_10 = false; //перенос строки
	int kol_fields_txt = 0;
	// Если нет символа перевода строки и нет ни одного зазделителя, то это значит пустой файл
	if (ubyte_str.length <= 3 ) {
		answer_str = "Empty file";
		return_value = 4; // Пустой файл;
		return 0;
		}
	// Проверим у последней строки наличие перевода строки и каретки
	if (ubyte_str[ubyte_str.length-2] != 13 && ubyte_str[ubyte_str.length-1] != 10) {
		if (ubyte_str[ubyte_str.length-1] != 13 && ubyte_str[ubyte_str.length-1] != 10) {
			ubyte_str = ubyte_str ~ cast(ubyte[])[13,10];
			}
		else {
			ubyte_str.replaceInPlace(ubyte_str.length-1, ubyte_str.length, cast(ubyte[])[13,10]);
			}
		}
			
	// Проверим txt фйал на 13.13.13.10 или что-то подобное и, если находим, то исправляем
	clear_wrong_enter(ubyte_str);
				
	int i=0;
	int j = 0;
	int max_value = 0;
	int min_value = 0;
	bool flag1 = false; // если строки в файле разной длинны
	bool flag2 = false; // если количество полей txt файла больше чем в структуре
	ubyte[] ubyte_9_10;
	for (i = 0; i<ubyte_str.length; i++) {
		if (ubyte_str[i] == 9) {
			kol_fields_txt++;
			}
		if (ubyte_str[i] == 13 && ubyte_str[i+1] == 10) {
			kol_fields_txt++;
			byte_10 = true;

			if (kol_fields_sql < kol_fields_txt) { // Если больше полей чем в sql структуре, то проверим чтобы лишние 
				flag2 = true;						// поля не несли с собой никаких символов, а только разделители, 
				ubyte_9_10 = [];					// которые дальше можно без ошибок убрать, но если встретим сивол в лишнем поле, то выдаем ошибку.
				for (int iii = 0; iii < (kol_fields_txt - kol_fields_sql); iii++) {
					ubyte_9_10 = ubyte_9_10 ~ cast(ubyte[])[9];
					}
				if (ubyte_str[i-(kol_fields_txt-kol_fields_sql)..i] != ubyte_9_10) {
					answer_str = "return 5";
					return_value = 5; // Количество полей в txt файле больше чем в sql структуре;
					return 0;
					}
				}

			if (kol_fields_txt < 1) {
				answer_str = "return 7";
				return_value = 7; // не верные разделители, например, пробелы вместо табуляции
				return 0;
				}

			// Это частный случай по госпитализации
			if (std.string.indexOf(special_case, "|1|")!=-1) {
				string fl_txt =	var4special_case[std.string.indexOf(var4special_case, "|1")+2 ..lastIndexOf(var4special_case, "1|")].strip();
				if ((fl_txt[lastIndexOf(fl_txt, "/")+1] == 'H') && (kol_fields_txt < 13)) {
					answer_str = "return 6";
					return_value = 6; // Колшичество полей в h*.txt меньше 13, значит старая версия.
					return 0;
					}
				}
			if (min_value == 0 || (min_value > kol_fields_txt)) {
				min_value = kol_fields_txt;
				}
			if (max_value > kol_fields_txt) {
				flag1 = true;
				}
			if (max_value < kol_fields_txt) {
				if (max_value > 0) {
					flag1 = true;
					}
				max_value = kol_fields_txt;
				}
			kol_fields_txt = 0;
			}
		}
	
	
	// Если в txt файле меньше полей чем в sql структуре и пользователь согласился
	// поправить это (добавить недостающее количество полей), то правим структуру
	i=0;
	j = 0;
	kol_fields_txt = 0;
	//if (max_value < kol_fields_sql || flag1 == true) { // Нужно ли править структуру текстового файла?
	if (min_value < kol_fields_sql) { // Нужно ли править структуру текстового файла?
		if (std.string.indexOf(special_case, "|2|")!=-1) { // Если пользователь согласился править
			// 1. Если записи разной длинны
			if (flag1 == true) {
				for (i = 0; i<ubyte_str.length; i++) {
					if (ubyte_str[i] == 9) {
						kol_fields_txt++;
						}
					if (ubyte_str[i] == 13 && ubyte_str[i+1] == 10) {
						kol_fields_txt++;
						byte_10 = true;
						
						if (max_value - kol_fields_txt > 0) {
							for (j = 0; j<(max_value-kol_fields_txt); j++) {
								ubyte_9_10 = ubyte_9_10 ~ cast(ubyte[])[9];
								}
							ubyte_str.replaceInPlace(i, i+2, ubyte_9_10 ~ cast(ubyte[])[13,10]);
							i = i + (max_value - kol_fields_txt)+1;
							ubyte_9_10 = [];
							}
						kol_fields_txt = 0;
						}
					}
				}
			// 2. Если во всех записях не хватает одинакового количества полей
			if (min_value < kol_fields_sql) {
				ubyte_9_10 = [];
				for (j = 0; j<(kol_fields_sql - min_value); j++) {
					ubyte_9_10 = ubyte_9_10 ~ cast(ubyte[])[9];
					}
				ubyte_str = replace(ubyte_str, [13,10], ubyte_9_10 ~ cast(ubyte[])[13,10]);
				}
			}
		else {
			answer_str = "return 8";
			return_value = 8; // В файле недостаточное количество полей
			return 0;
			}
		}
	
	// Если в txt файле БОЛЬШЕ полей чем в sql структуре,
	// то правим структуру, если это возможно, убирая поля, только, если они пустые, иначе выдаем ошибку		
	i=0;
	j = 0;
	kol_fields_txt = 0;
	if (flag2 == true) { // Нужно ли убирать лишние поля?
		// 1. Если записи разной длинны
		if (flag1 == true) {
			for (i = 0; i<ubyte_str.length; i++) {
				if (ubyte_str[i] == 9) {
					kol_fields_txt++;
					}
				if (ubyte_str[i] == 13 && ubyte_str[i+1] == 10) {
					kol_fields_txt++;
					byte_10 = true;
					
					if (kol_fields_txt - kol_fields_sql > 0) {
						ubyte_str.replaceInPlace(i - (kol_fields_txt - kol_fields_sql), i+2, cast(ubyte[])[13,10]);
						i = i + (kol_fields_txt - kol_fields_sql)+1;
						}
					kol_fields_txt = 0;
					}
				}
			}
		// 2. Если во всех записях превышено одинаковое количество полей
		if (max_value > kol_fields_sql && flag1 == false) {
			ubyte_9_10 = [];
			for (j = 0; j<(max_value - kol_fields_sql); j++) {
				ubyte_9_10 = ubyte_9_10 ~ cast(ubyte[])[9];
				}
			ubyte_9_10 = ubyte_9_10 ~ cast(ubyte[])[13,10];
			ubyte_str = replace(ubyte_str, ubyte_9_10,  cast(ubyte[])[13,10]);
			}
		}
		 
	//return 0;
	
	
	// И пошли делать проверку и считаем суммы
	int field_name = 2; // Индекс поля массива со структурой - тип
	int field_type = 3; // Индекс поля массива со структурой - тип
	int field_null = 4; // Индекс поля массива со структурой - null 
	int field_length = 5; // Индекс поля массива со структурой - величина поля
	int field_drobn = 7; // Индекс поля массива со структурой - дробная часть поля
	ubyte[] ubyte_value = [];
	
	//--------- Оределим переменные для формирования ошибок -----------
	string number_str_fld = "";
	string error_length = "";
	string error_value = "";
	string error_null = "";
	string error_serv_struct = "";
	string _sql_struct4err = "";
	//------------------------------------------------------------------
	int count_dots = 0; // Количество точек в дробных числах
	i=0;
	int txt_numeric_length = 0; // Длинна по факту числового поля в текстовом файле
	int sql_numeric_length = 0; // Длинна по факту числового поля на sql сервере
	
	//------------------------------------------------------------------------
	// Проверим типы структуры
	for (n_column=0; n_column<array_struct.length; n_column++) {
		if (!(strip(array_struct[n_column][field_type]) == "datetime" ||
				strip(array_struct[n_column][field_type]) == "smalldatetime" ||
				strip(array_struct[n_column][field_type]) == "bit" ||
				strip(array_struct[n_column][field_type]) == "char" || 
				strip(array_struct[n_column][field_type]) == "nchar" || 
				strip(array_struct[n_column][field_type]) == "varchar" ||
				strip(array_struct[n_column][field_type]) == "nvarchar" ||
				strip(array_struct[n_column][field_type]) == "text" ||
				strip(array_struct[n_column][field_type]) == "ntaxt" ||
				strip(array_struct[n_column][field_type]) == "int" ||
				strip(array_struct[n_column][field_type]) == "bigint" ||
				strip(array_struct[n_column][field_type]) == "numeric" ||
				strip(array_struct[n_column][field_type]) == "decimal")) {
			
			answer_str = "__err_value   Unspecified type " ~ array_struct[n_column][field_type] ~ " in the table structure on the server ";
			return_value = 41;
			return 0;
			}
		}
	n_column = 0;
	n_row = 0;
	//------------------------------------------------------------------------
	
	//auto rr = 0; if (rr<2) {return 100;}
	while (i < ubyte_str.length) {
		ubyte_9_10 = [];
		ubyte_9_10 = ubyte_str[i..ubyte_str.length][0..countUntil(ubyte_str[i..ubyte_str.length], [13,10])] ~ cast(ubyte[])[9];
		
		// Пошли по столбцам
		j=0;
		n_column = 0;
		sql_numeric_length = 0;
		txt_numeric_length = 0;
		while (j < ubyte_9_10.length) {
			//---------------- Сформируем строки ошибок заранее, чтоб потом подставлять -------------
			//number_str_fld = "__err_value   s" ~ std.conv.to!string(n_row+1) ~ ":f" ~ std.conv.to!string(n_column+1) ~ " ";
			//error_length = "invalid "~array_struct[n_column][field_type]~" length ";
			//error_value = "invalid "~array_struct[n_column][field_type]~" value ";
			//error_null = "type "~array_struct[n_column][field_type]~" is not nullable ";
			
			//---------------------------------------------------------------------------------------
			count_dots = 0;
			ubyte_value = [];
			ubyte_value = ubyte_9_10[j..ubyte_9_10.length][0..countUntil(ubyte_9_10[j..ubyte_9_10.length], [9])];
			
			//Идем в структуру
			// Пойдем по частным случаям
			//------------------------------- Дата ---------------------------------
			// SQL server принимает несколько вариантов даты. Например:
			// yyyy.dd.mm, yyyy-mm-dd, dd/mm/yyyy, dd.mm.yyyy ...
			// В этой программе я проверяю только на: dd.mm.yyyy.
			// Если попадется другой тип даты, то будет ошибка.
			
			if (strip(array_struct[n_column][field_type]) == "datetime" ||
				strip(array_struct[n_column][field_type]) == "smalldatetime") {
				
				// Очистим от пробелов
				strip_ubyte(ubyte_value, 3);
				
				// Проверим на null
				if (strip(array_struct[n_column][field_null]) == "no" && ubyte_value == []) {
					answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "null");
					return_value = 40; // Ошибка NULL 
					return 0;
					}				
				
				if (ubyte_value.length > 0) {
					// Проверим длинну
					if (ubyte_value.length != 10) {
						answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "length");
						return_value = 31;
						return 0;
						}
					// Проверим расположение точек - разделителей
					//if ((cast(int)ubyte_value[2]!=46 || cast(int)ubyte_value[5]!=46) && (cast(int)ubyte_value[2]!=45 || cast(int)ubyte_value[5]!=45)) {
					//	//writeln(ubyte_value);						
					//	answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "value");
					//	return_value = 31;
					//	return 0;
					//	}
					// Проверим расположение точек - разделителей
					if  ((cast(int)ubyte_value[2]!=46 || cast(int)ubyte_value[5]!=46) && (cast(int)ubyte_value[2]!=45 || cast(int)ubyte_value[5]!=45) &&
						(cast(int)ubyte_value[4]!=46 || cast(int)ubyte_value[7]!=46) && (cast(int)ubyte_value[4]!=45 || cast(int)ubyte_value[7]!=45) &&
						(cast(int)ubyte_value[4]!=47 || cast(int)ubyte_value[7]!=47)) {
						answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "value");
						return_value = 31;
						return 0;
						}
					// Убедившись, что value - это триада дниной из 10 символов вида:
					// yyyy.dd.mm, yyyy-mm-dd, dd/mm/yyyy, dd.mm.yyyy ...,
					// преобразуем значение value к единому виду для быстрой проверки.
					if ((cast(int)ubyte_value[4]==45 && cast(int)ubyte_value[7]==45) || (cast(int)ubyte_value[4]==46 && cast(int)ubyte_value[7]==46) ||
						(cast(int)ubyte_value[4]==47 && cast(int)ubyte_value[7]==47)){
						ubyte_value = ubyte_value[8..ubyte_value.length] ~ cast(ubyte[])[46] ~ ubyte_value[5..7] ~ cast(ubyte[])[46] ~ ubyte_value[0..4];
						}
					// Проверим каждый блок даты: день, месяц, год (dd.mm.yyyy)
					if (find([48,49,50,51],ubyte_value[0]) == [] || find([48,49,50,51,52,53,54,55,56,57],ubyte_value[1]) == [] ||
						find([48,49],ubyte_value[3]) == [] || find([48,49,50,51,52,53,54,55,56,57],ubyte_value[4]) == [] ||
						find([49,50],ubyte_value[6]) == [] || find([48,57],ubyte_value[7]) == [] ||
						find([48,49,50,51,52,53,54,55,56,57],ubyte_value[8]) == [] || find([48,49,50,51,52,53,54,55,56,57],ubyte_value[7]) == []) {
						answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "value");
						return_value = 31;
						return 0;
						}
					// Проверим max и min кол-во дней (31)
					if (std.conv.to!int(cast(string)ubyte_value[0..2])<1 || std.conv.to!int(cast(string)ubyte_value[0..2])>31) {
						answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "value");
						return_value = 31;
						return 0;
						}
					// Проверим max и min кол-во месяцев (12)
					if (std.conv.to!int(cast(string)ubyte_value[3..5])<1 || std.conv.to!int(cast(string)ubyte_value[3..5])>12) {
						answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "value");
						return_value = 31;
						return 0;
						}
					// Проверим max и min кол-во лет (1800 - 2030)
					if (std.conv.to!int(cast(string)ubyte_value[6..10])<1899 || std.conv.to!int(cast(string)ubyte_value[6..10])>2030) {
						answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "value");
						return_value = 31;
						return 0;
						}
					}
				}
			//------------------------------- Логический тип поля --------------------------------------
			if (strip(array_struct[n_column][field_type]) == "bit") {
				// Очистим пробелы слева, если они есть
				strip_ubyte(ubyte_value, 1);
				// Проверим на null
				if (strip(array_struct[n_column][field_null]) == "no" && ubyte_value == []) {
					answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "null");
					return_value = 40;
					return 0;
					}
				if (ubyte_value.length > 0) {
					// Проверим на пробелы после логического значения
					for (int ii = 0; ii<ubyte_value.length; ii++) {
						if (cast(int)ubyte_value[ii]==32) {
							answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "value");
							return_value = 32;
							return 0;
							}
						}
					// Проверим длинну
					//if (ubyte_value.length > std.conv.to!int(array_struct[n_column][field_length])) {
					if (ubyte_value.length > 1) {
						answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "length");
						return_value = 32;
						return 0;
						}
					// Проверим на допустимые значения
					if (find([48,49],ubyte_value) == []) {
						answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "value");
						return_value = 32;
						return 0;
						}
					}
				}
			//-------------------------------- Строковые данные ----------------------------------------
			if (strip(array_struct[n_column][field_type]) == "char" || 
							strip(array_struct[n_column][field_type]) == "nchar" || 
							strip(array_struct[n_column][field_type]) == "varchar" || 
							strip(array_struct[n_column][field_type]) == "nvarchar") {
				// ВАЖНО!!! Символьные данные типов CHAR, NCHAR, VARCHAR, NVARCHAR не надо проверять на NULL, 
				// пустые строки принимаются без ошибок, если поле не NULLABLE.
				if (ubyte_value.length > 0) {
					// Проверим длинну
					if (ubyte_value.length > std.conv.to!int(array_struct[n_column][field_length])) {
						answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "length");
						return_value = 33;
						return 0;
						}
					}
				}
			if (strip(array_struct[n_column][field_type]) == "text" ||
						strip(array_struct[n_column][field_type]) == "ntext") {
				// А вот типы TEXT и NTEXT не принимают пустых знгачений при не NULLABLE.
				// Проверим на null
				if (strip(array_struct[n_column][field_null]) == "no" && ubyte_value == []) {
					answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "null");
					return_value = 40;
					return 0;
					}
				// Длина полей TEXT и NTEXT фиксированная, и они гораздо длиннее чем типы *CHAR. 
				// Длина TEXT = 2 147 483 647(не юникод), NTEXT = 1 073 741 823(юникод). Это оооооочень много, пока не проверяю...
				}
			//------------------------------------ Числа ----------------------------------------------
			if (strip(array_struct[n_column][field_type]) == "int" ||
						strip(array_struct[n_column][field_type]) == "bigint" ||
						strip(array_struct[n_column][field_type]) == "numeric" ||
						strip(array_struct[n_column][field_type]) == "decimal") {
				// Очистим от пробелов
				strip_ubyte(ubyte_value, 3);
				// Проверим на null
				if (strip(array_struct[n_column][field_null]) == "no" && ubyte_value == []) {
					answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "null");
					return_value = 40;
					return 0;
					}
				if (ubyte_value.length > 0) {
					// Может быть число и с минусом. Для того, чтобы его проверить так же как и положительные числа,
					// обрежем этот минус, если он есть, и пойдем дальше проверять. как будто это положительное число.
					// Если встретиться еще один минус, то это уже будет ошибкой.
					if (ubyte_value[0] == 45) {
						ubyte_value = ubyte_value[1..ubyte_value.length];
						}
					// Если это значение просто точка
					if (ubyte_value == [46]) {
						answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "value");
						return_value = 34;
						return 0;
						}
					// Определим, число ли это вообще
					for (int ii = 0; ii<ubyte_value.length; ii++) {
						if (cast(int)ubyte_value[ii]==46) {							
							count_dots++;
							}
						if (find([46,48,49,50,51,52,53,54,55,56,57],ubyte_value[ii]) == [] || count_dots > 1) {
							answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "value");
							return_value = 34;
							return 0;
							}
						}
					// Если точка стоит в начале или в конце
					if (cast(int)ubyte_value[0]==46) { // если в начале
						ubyte_value = cast(ubyte[])[48] ~ ubyte_value;
						}
					if (cast(int)ubyte_value[ubyte_value.length-1]==46) { // если в конце
						ubyte_value = ubyte_value[0..ubyte_value.length-1];
						}
					// Если число с дробной частью а тип поля на сервере без дробной, то выдадим ошибку
					if ((strip(array_struct[n_column][field_drobn]) == "" || strip(array_struct[n_column][field_drobn]) == "0") &&
							find(ubyte_value,[46]) != []) {
						answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "value");
						return_value = 34;
						return 0;
						}
					// Проверим длинну после определения числа: дробное или целое
					// Вычислим длинну числовой записи и длинну поля sql таблицы (т.к. при наличии дробной части, основная уменьшается)
					if (find(ubyte_value,[46]) == []) {txt_numeric_length = cast(int)ubyte_value.length; }
					else {txt_numeric_length = cast(int)countUntil(ubyte_value, [46]);}
					// Если число вида "03434345" или "02.987", с нулем вначеле, то выдаем ошибку.
					if (ubyte_value[0] == 48 && txt_numeric_length > 1) {
						// Проверим, если все нули, то пропустим
						for (int ii = 0; ii<ubyte_value.length; ii++) {
							if (cast(int)ubyte_value[ii]!=48) {
								//writeln(UTF8_CP866("Тут"));
								answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "value");
								return_value = 34;
								return 0;
								}
							}
						}
					// Длинна поля на SQL
					if (std.conv.to!int(cast(string)strip(array_struct[n_column][field_drobn])) == 0) {
						sql_numeric_length = std.conv.to!int(cast(string)strip(array_struct[n_column][field_length]));
						}
					else {
						sql_numeric_length = std.conv.to!int(cast(string)strip(array_struct[n_column][field_length]))-std.conv.to!int(cast(string)strip(array_struct[n_column][field_drobn]));
						}
					// Если, напеример на сервере целая часть числа задана 1 и дробная часть числа задана 1 или 2 к 2 или 3 к 3, то
					// это дробное число обязательно должно быть вида "0.дробная_часть". Т.е. в данном случае 0 - всегда целая часть числа в txt.
					if (sql_numeric_length == 0 && ubyte_value[0] != 48) {
						answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "value");
						return_value = 34;
						return 0;
						}
					// Сравним длинну значения из txt файла с длинной из структуры sql
					//if (txt_numeric_length > sql_numeric_length && sql_numeric_length > 0) {
					if (txt_numeric_length > sql_numeric_length && sql_numeric_length > 0) {
						answer_str = generate_answer(array_struct[n_column][field_type], n_row, n_column, "length");
						return_value = 34;
						return 0;
						}
					}
				}
			j = j + cast(int)countUntil(ubyte_9_10[j..ubyte_9_10.length], [9])+1;
			n_column++;
			}
		n_row++;
		i = i + cast(int)countUntil(ubyte_str[i..ubyte_str.length], [13,10])+2;
		}
	return 0;
}
//---------------------------------------------------------------------------------------------

// Функция проверки текстовых файлов с помощью полученной структуры SQL сервера
int check_utf_file(ref string utf_str,string fl_struct_str,ref string answer_str,ref int return_value,string special_case, string var4special_case) {
	// ubyte_str - это проверяемый файл открытый побайтово
	// fl_struct_str - это файл структуры таблицы на сервере, открытый символьной строкой. Этой структурой нужно проверить открытый файл ubyte_str.
	// answer_str - это строка ответа вызывающей программе. Туда пишеться ошибка для представления на сервере.
	// return_value - номер ошибки (после обработки ubyte_str) для вызывающей программы.
	// special_case - частный случай. Напимер один частный случай: |1| или несколько: |1|2|5|9|10|
	// var4special_case - этот папаметр вспомогательный, он служит для передачи доп инф для частногшо случая. Например, 
	// для частного случая |1| можно передать имя файла: |1 имя_файла 1| .Вспомогательных данных может быть несколько для нескольких частных случаев,
	// например: |1 имя_файла 1|2 для_2-го_частного_случая 2|10 для_10-го 10|254 для_254-го 254|
	
	//Получим количество столбцов и строк из файла структуры
	int n_column = 0;
	int n_row = 0;
	foreach(line; fl_struct_str.splitLines()) {
		if (n_row == 0) {
			n_column = cast(int)count(line, "\t") + 1;
			}
		n_row++;
		}
	int kol_fields_sql = n_row;
	
	//array_struct[номер_столбца][номер_строки]
	enum column_const = 15;	
	auto array_struct = new string[column_const][kol_fields_sql];

	// Преобразуем текст в массив данных
	n_column = 0;
	n_row = 0; 
	foreach(line; fl_struct_str.splitLines()) {
		// В цикле заполняем элементы массива array_struct строками из file_str
		n_column = 0;
		while (std.string.indexOf(line, "\t")!=-1) {
			array_struct[n_row][n_column] = line[0 .. std.string.indexOf(line, "\t")];
			line = line[std.string.indexOf(line, "\t")+1 .. line.length];
			n_column++;
			}
		array_struct[n_row][n_column] = line[0 .. line.length];
		n_row++;
		}
	
	//--------- Оределим переменные для формирования ошибок -----------
	string number_str_fld = "";
	string error_length = "";
	string error_value = "";
	string error_null = "";
	string error_serv_struct = "";
	string _sql_struct4err = "";
	//------------------------------------------------------------------	
	// Пошли проверять значение каждого поля
	int yy = 0;
	string value_ = "";	
	n_column = 0;
	n_row = 0;
	int field_name = 2; // Индекс поля массива со структурой - тип
	int field_type = 3; // Индекс поля массива со структурой - тип
	int field_null = 4; // Индекс поля массива со структурой - null 
	int field_length = 5; // Индекс поля массива со структурой - величина поля
	int field_drobn = 7; // Индекс поля массива со структурой - дробная часть поля

	// Проверим типы структуры
	for (n_column=0; n_column<array_struct.length; n_column++) {
	
		if (!(strip(array_struct[n_column][field_type]) == "datetime" ||
				strip(array_struct[n_column][field_type]) == "smalldatetime" ||
				strip(array_struct[n_column][field_type]) == "bit" ||
				strip(array_struct[n_column][field_type]) == "char" || 
				strip(array_struct[n_column][field_type]) == "nchar" || 
				strip(array_struct[n_column][field_type]) == "varchar" || 
				strip(array_struct[n_column][field_type]) == "nvarchar" ||
				strip(array_struct[n_column][field_type]) == "text" ||
				strip(array_struct[n_column][field_type]) == "ntaxt" ||
				strip(array_struct[n_column][field_type]) == "int" ||
				strip(array_struct[n_column][field_type]) == "bigint" ||
				strip(array_struct[n_column][field_type]) == "numeric" ||
				strip(array_struct[n_column][field_type]) == "decimal")) {
			
			answer_str = number_str_fld ~ error_serv_struct ~ _sql_struct4err;
			return_value = 41;
			writeln(return_value);
			return 0;
			}
		}
	
	n_column = 0;
	foreach(line; utf_str.splitLines()) {
		n_column = 0;
		while (std.string.indexOf(line, "\t")!=-1) {
			//Идем в структуру
			value_ = line[0 .. std.string.indexOf(line, "\t")];
			
			
			
			// Пойдем по частным случаям
			//------------------------------- Дата ---------------------------------
			// SQL server принимает несколько вариантов даты. Например:
			// yyyy.dd.mm, yyyy-mm-dd, dd/mm/yyyy, dd.mm.yyyy ...
			// В этой программе я проверяю только на: dd.mm.yyyy.
			// Если попадется другой тип даты, то будет ошибка.
			if (strip(array_struct[n_column][field_type]) == "datetime" ||
				strip(array_struct[n_column][field_type]) == "smalldatetime") {
				
				}
			
			line = line[std.string.indexOf(line, "\t")+1 .. line.length];
			n_column++;
			}
		n_row++;
		}
	writeln(n_row);
	writeln(n_column);
	return 0;
}

//---------------------------------------------------------------------------------------------
// Функция подготовки txt файлов для загрузки на sql. Например, чистит " 
// или логические значения FxPro (F, T) заменяет на логические значения sql server. 
// Могут быть также пустые даты, напимер '. .', их нужно заменить просто на empty, и т.д.

int prepare_txt4sql(ref ubyte[] ubyte_str) {
	// Поискать максимальное коль-во логических полей, стоящих рядом и 
	// затем выполнить такое же кол-во раз replace.
	//int i = 0;
	//int j = 0;
	//int kol_F = 0;
	//int kol_T = 0;
	//int kol_empty_date = 0;
	//int tmp_kol_F = 0;
	//int tmp_kol_T = 0;
	//int tmp_kol_empty_date = 0;
	
	//int n_column = 0;
	//int n_row = 0;
	//ubyte[] ubyte_9_10 = [];
	//ubyte[] ubyte_value = [];
	
	//while (i < ubyte_str.length) {
		//ubyte_9_10 = [];
		//ubyte_9_10 = ubyte_str[i..ubyte_str.length][0..countUntil(ubyte_str[i..ubyte_str.length], [13,10])] ~ cast(ubyte[])[9];
		//j = 0;
		//while (j < ubyte_9_10.length) {
			//ubyte_value = [];
			//ubyte_value = ubyte_9_10[j..ubyte_9_10.length][0..countUntil(ubyte_9_10[j..ubyte_9_10.length], [9])];
			//strip_ubyte(ubyte_value, 3);
			//// Начало проверки
			//// Проверим F
			//if (ubyte_value == cast(ubyte[])[70]) {
				//tmp_kol_F++;
				//}
			//if (ubyte_value == cast(ubyte[])[84]) {
				//tmp_kol_F++;
				//}
			//// Конец проверки
			//j = j + countUntil(ubyte_9_10[j..ubyte_9_10.length], [9])+1;
			//}
		//// Переприсвоим набранные значения
		//if (kol_F < tmp_kol_F) {
			//kol_F = tmp_kol_F;
			//}
		//if (kol_T < tmp_kol_T) {
			//kol_T = tmp_kol_T;
			//}
		//if (kol_empty_date < tmp_kol_empty_date) {
			//kol_empty_date = tmp_kol_empty_date;
			//}
		//tmp_kol_F = 0;
		//tmp_kol_T = 0;
		//tmp_kol_empty_date = 0;
			
		//i = i + countUntil(ubyte_str[i..ubyte_str.length], [13,10])+2;
		//}
	
	

	//for (i = 0; i<ubyte_str.length; i++) {
		//// Проверим F
		//if (i > 0 && ubyte_str[i-1..i] == cast(ubyte[])[9]) {
			//if (i > 0 && i < ubyte_str.length - 1 && ubyte_str[i-1..i+2] == cast(ubyte[])[9,70,9]) {
				//tmp_kol_F++;
				//}
			//// Проверим T
			//if (i > 0 && i < ubyte_str.length - 1 && ubyte_str[i-1..i+2] == cast(ubyte[])[9,84,9]) {
				//tmp_kol_T++;
				//}
			//// Проверим '.  .'
			//if (i > 0 && i < ubyte_str.length - 5 && ubyte_str[i-1..i+5] == cast(ubyte[])[9,46,32,32,46,9]) {
				//tmp_kol_empty_date++;
				//}
			//}
		
		//if (ubyte_str[i] == 13 && ubyte_str[i+1] == 10) {
			//// Переприсвоим набранные значения
			//if (kol_F < tmp_kol_F) {
				//kol_F = tmp_kol_F;
				//}
			//if (kol_T < tmp_kol_T) {
				//kol_T = tmp_kol_T;
				//}
			//if (kol_empty_date < tmp_kol_empty_date) {
				//kol_empty_date = tmp_kol_empty_date;
				//}
			//tmp_kol_F = 0;
			//tmp_kol_T = 0;
			//tmp_kol_empty_date = 0;
			//}
		//}
	
	//writeln("kol_F = ", kol_F);
	//writeln("------------------");
	//writeln("kol_T = ", kol_T);
	//writeln("------------------");
	//writeln("kol_empty_date = ", kol_empty_date);
	//writeln(" ");

	//// Поправим, если нашли все центровые символы
	//if (kol_F > 0) { //F
		//for (i = 0; i<kol_F; i++) {
			//ubyte_str = replace(ubyte_str, [9,70,9], cast(ubyte[])[9,48,9]);
			//}
		//}
	//if (kol_T > 0) { //T
		//for (i = 0; i<kol_T; i++) {
			//ubyte_str = replace(ubyte_str, [9,84,9], cast(ubyte[])[9,49,9]);
			//}
		//}
	//if (kol_empty_date > 0) { //'.  .'
		//for (i = 0; i<kol_empty_date; i++) {
			//ubyte_str = replace(ubyte_str, [9,46,32,32,46,9], cast(ubyte[])[9,9]);
			//}
		//}
	// Почистим от кавычек
	ubyte_str = replace(ubyte_str, [34], cast(ubyte[])[]);
	// Нужно именно 2 раза сделать, т.к. перескок идет через одно поле, 
	// и вторым разом все перескоки также почистяться.
	ubyte_str = replace(ubyte_str, [9,70,9], cast(ubyte[])[9,48,9]);
	ubyte_str = replace(ubyte_str, [9,70,9], cast(ubyte[])[9,48,9]);
	ubyte_str = replace(ubyte_str, [9,84,9], cast(ubyte[])[9,49,9]);
	ubyte_str = replace(ubyte_str, [9,84,9], cast(ubyte[])[9,49,9]);
	ubyte_str = replace(ubyte_str, [9,46,32,32,46,9], cast(ubyte[])[9,9]);
	ubyte_str = replace(ubyte_str, [9,46,32,32,46,9], cast(ubyte[])[9,9]);

	// Также поправим 1-й и последний столбцы, если там есть исключения
	// Проверим самое первое значение в файле
	if (ubyte_str[0..2] == [70,9]) {ubyte_str.replaceInPlace(0, 2, cast(ubyte[])[48,9]);} //F	
	if (ubyte_str[0..2] == [84,9]) {ubyte_str.replaceInPlace(0, 2, cast(ubyte[])[49,9]);} //T
	if (ubyte_str[0..5] == [46,32,32,46,9]) {ubyte_str.replaceInPlace(0, 5, cast(ubyte[])[9]);} //'.  .'
	
	// И все значения, с которых начинается строка и заканчивается
	//F
	ubyte_str = replace(ubyte_str, [13,10,70,9], cast(ubyte[])[13,10,48,9]);
	ubyte_str = replace(ubyte_str, [9,70,13,10], cast(ubyte[])[9,48,13,10]);
	//T
	ubyte_str = replace(ubyte_str, [13,10,84,9], cast(ubyte[])[13,10,49,9]);
	ubyte_str = replace(ubyte_str, [9,84,13,10], cast(ubyte[])[9,49,13,10]);
	//'.  .'
	ubyte_str = replace(ubyte_str, [13,10,46,32,32,46,9], cast(ubyte[])[13,10,9]);
	ubyte_str = replace(ubyte_str, [9,46,32,32,46,13,10], cast(ubyte[])[9,13,10]);
	return 0;
}
