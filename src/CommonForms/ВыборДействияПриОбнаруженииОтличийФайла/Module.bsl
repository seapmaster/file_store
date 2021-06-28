///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(
		ЭтотОбъект,
		Параметры,
		"ДатаИзмененияВРабочемКаталоге,
		|ДатаИзмененияВХранилищеФайлов,
		|ПолноеИмяФайлаВРабочемКаталоге,
		|РазмерВРабочемКаталоге,
		|РазмерВХранилищеФайлов,
		|Сообщение,
		|Заголовок");
		
	ТестНовее = " (" + НСтр("ru = 'новее'") + ")";
	Если ДатаИзмененияВРабочемКаталоге > ДатаИзмененияВХранилищеФайлов Тогда
		ДатаИзмененияВРабочемКаталоге = Строка(ДатаИзмененияВРабочемКаталоге) + ТестНовее;
	Иначе
		ДатаИзмененияВХранилищеФайлов = Строка(ДатаИзмененияВХранилищеФайлов) + ТестНовее;
	КонецЕсли;
	
	Элементы.Сообщение.Высота = СтрЧислоСтрок(Сообщение) + 2;
	
	Если Параметры.ДействиеНадФайлом = "ПомещениеВХранилищеФайлов" Тогда
		
		Элементы.ФормаОткрытьСуществующий.Видимость = Ложь;
		Элементы.ФормаВзятьИзХранилища.Видимость    = Ложь;
		Элементы.ФормаПоместить.КнопкаПоУмолчанию   = Истина;
		
	ИначеЕсли Параметры.ДействиеНадФайлом = "ОткрытиеВРабочемКаталоге" Тогда
		
		Элементы.ФормаПоместить.Видимость  = Ложь;
		Элементы.ФормаНеПомещать.Видимость = Ложь;
		Элементы.ФормаОткрытьСуществующий.КнопкаПоУмолчанию = Истина;
	Иначе
		ВызватьИсключение НСтр("ru = 'Неизвестное действие над файлом'");
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
		Элементы.ЗначокСообщения.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСуществующий(Команда)
	
	Закрыть("ОткрытьСуществующий");
	
КонецПроцедуры

&НаКлиенте
Процедура Поместить(Команда)
	
	Закрыть("ПОМЕСТИТЬ");
	
КонецПроцедуры

&НаКлиенте
Процедура ВзятьИзПрограммы(Команда)
	
	Закрыть("ВзятьИзХранилищаИОткрыть");
	
КонецПроцедуры

&НаКлиенте
Процедура НеПомещать(Команда)
	
	Закрыть("НеПомещать");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталог(Команда)
	
	РаботаСФайламиСлужебныйКлиент.ОткрытьПроводникСФайлом(ПолноеИмяФайлаВРабочемКаталоге);
	
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	
	Закрыть("Отменить");
	
КонецПроцедуры

#КонецОбласти
