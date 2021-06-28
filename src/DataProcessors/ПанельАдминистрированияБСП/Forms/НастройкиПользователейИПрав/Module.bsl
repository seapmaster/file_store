///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Пользователи.ОбщиеНастройкиВходаИспользуются() Тогда
		Элементы.ГруппаНастройкиВходаПользователей.Видимость = Ложь;
		Элементы.ГруппаСписокВнешнихПользователейОтступ.Видимость = Ложь;
		Элементы.ГруппаНастройкиВходаВнешнихПользователей.Видимость = Ложь;
		Элементы.ГруппаВнешниеПользователи.Группировка
			= ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено()
	 Или СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
	 Или ОбщегоНазначения.ЭтоАвтономноеРабочееМесто()
	 Или Не ПользователиСлужебный.ВнешниеПользователиВнедрены() Тогда
	
		Элементы.ГруппаВнешниеПользователи.Видимость = Ложь;
		Элементы.ОписаниеРаздела.Заголовок =
			НСтр("ru = 'Администрирование пользователей, настройка групп доступа, управление пользовательскими настройками.'");
	КонецЕсли;
	
	Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
	 Или ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		
		Элементы.ИспользоватьГруппыПользователей.Доступность = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		УпрощенныйИнтерфейс = МодульУправлениеДоступомСлужебный.УпрощенныйИнтерфейсНастройкиПравДоступа();
		Элементы.ОткрытьГруппыДоступа.Видимость            = НЕ УпрощенныйИнтерфейс;
		Элементы.ИспользоватьГруппыПользователей.Видимость = НЕ УпрощенныйИнтерфейс;
		Элементы.ОграничиватьДоступНаУровнеЗаписейУниверсально.Видимость
			= Пользователи.ЭтоПолноправныйПользователь(, Истина);
		Элементы.ОбновлениеДоступаНаУровнеЗаписей.Видимость =
			Элементы.ОграничиватьДоступНаУровнеЗаписейУниверсально.Видимость
			И МодульУправлениеДоступомСлужебный.ОграничиватьДоступНаУровнеЗаписейУниверсально(Истина);
		
		Если ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
			Элементы.ОграничиватьДоступНаУровнеЗаписей.Доступность = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ГруппаГруппыДоступа.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
		Элементы.ГруппаДатыЗапретаИзменения.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗащитаПерсональныхДанных") Тогда
		Элементы.ГруппаОткрытьНастройкиРегистрацииСобытийДоступаКПерсональнымДанным.Видимость =
			  Не ОбщегоНазначения.РазделениеВключено()
			И Пользователи.ЭтоПолноправныйПользователь(, Истина);
	Иначе
		Элементы.ГруппаЗащитаПерсональныхДанных.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено()
		 Или Не ПользователиСлужебныйПовтИсп.ВерсияПредприятияПоддерживаетВосстановлениеПаролей() Тогда
			Элементы.ВосстановлениеПаролей.Видимость = Ложь;
	КонецЕсли;
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
	НастройкиПрограммыПереопределяемый.НастройкиПользователейИПравПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник = "ИспользоватьАнкетирование" 
		И ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Анкетирование") Тогда
		
		Прочитать();
		УстановитьДоступность();
		
	ИначеЕсли Источник = "ИспользоватьСкрытиеПерсональныхДанныхСубъектов" Тогда
		Прочитать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьГруппыПользователейПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОграничиватьДоступНаУровнеЗаписейУниверсальноПриИзменении(Элемент)
	
	Если НаборКонстант.ОграничиватьДоступНаУровнеЗаписейУниверсально Тогда
		ТекстВопроса =
			НСтр("ru = 'Включить производительный вариант ограничения доступа?
			           |
			           |Включение произойдет после окончания первого обновления
			           |(см. ход по ссылке ""Обновление доступа на уровне записей"").'");
	ИначеЕсли НаборКонстант.ОграничиватьДоступНаУровнеЗаписей Тогда
		ТекстВопроса =
			НСтр("ru = 'Выключить производительный вариант ограничения доступа?
			           |
			           |Потребуется заполнение данных, которое будет выполняться частями
			           |регламентным заданием ""Заполнение данных для ограничения доступа""
			           |(ход выполнения в журнале регистрации).'");
	Иначе
		ТекстВопроса =
			НСтр("ru = 'Выключить производительный вариант ограничения доступа?
			           |
			           |Потребуется частичное заполнение данных, которое будет выполняться частями
			           |регламентным заданием ""Заполнение данных для ограничения доступа""
			           |(ход выполнения в журнале регистрации).'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстВопроса) Тогда
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ОграничиватьДоступНаУровнеЗаписейУниверсальноПриИзмененииЗавершение",
				ЭтотОбъект, Элемент),
			ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ОграничиватьДоступНаУровнеЗаписейУниверсальноПриИзмененииЗавершение(КодВозвратаДиалога.Да, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОграничиватьДоступНаУровнеЗаписейПриИзменении(Элемент)
	
	Если НаборКонстант.ОграничиватьДоступНаУровнеЗаписейУниверсально Тогда
		ТекстВопроса =
			НСтр("ru = 'Настройки групп доступа вступят в силу постепенно
			           |(см. ход по ссылке ""Обновление доступа на уровне записей"").
			           |
			           |Обновление доступа может замедлить работу программы и выполняться
			           |от нескольких секунд до часов (в зависимости от объема данных).'");
		Если НаборКонстант.ОграничиватьДоступНаУровнеЗаписей Тогда
			ТекстВопроса = НСтр("ru = 'Включить ограничение доступа на уровне записей?'")
				+ Символы.ПС + Символы.ПС + ТекстВопроса;
		Иначе
			ТекстВопроса = НСтр("ru = 'Выключить ограничение доступа на уровне записей?'")
				+ Символы.ПС + Символы.ПС + ТекстВопроса;
		КонецЕсли;
		
	ИначеЕсли НаборКонстант.ОграничиватьДоступНаУровнеЗаписей Тогда
		ТекстВопроса =
			НСтр("ru = 'Включить ограничение доступа на уровне записей?
			           |
			           |Потребуется заполнение данных, которое будет выполняться частями
			           |регламентным заданием ""Заполнение данных для ограничения доступа""
			           |(ход выполнения в журнале регистрации).
			           |
			           |Выполнение может сильно замедлить работу программы и выполняться
			           |от нескольких секунд до многих часов (в зависимости от объема данных).'");
	Иначе
		ТекстВопроса = "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстВопроса) Тогда
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ОграничиватьДоступНаУровнеЗаписейПриИзмененииЗавершение",
				ЭтотОбъект, Элемент),
			ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ОграничиватьДоступНаУровнеЗаписейПриИзмененииЗавершение(КодВозвратаДиалога.Да, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВнешнихПользователейПриИзменении(Элемент)
	
	Если НаборКонстант.ИспользоватьВнешнихПользователей Тогда
		
		ТекстВопроса =
			НСтр("ru = 'Разрешить доступ внешним пользователям?
			           |
			           |При входе в программу список выбора пользователей станет пустым
			           |(реквизит ""Показывать в списке выбора"" в карточках всех
			           | пользователей будет очищен и скрыт).'");
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ИспользоватьВнешнихПользователейПриИзмененииЗавершение",
				ЭтотОбъект,
				Элемент),
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
	Иначе
		ТекстВопроса =
			НСтр("ru = 'Запретить доступ внешним пользователям?
			           |
			           |Реквизит ""Вход в программу разрешен"" будет
			           |очищен в карточках всех внешних пользователей.'");
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ИспользоватьВнешнихПользователейПриИзмененииЗавершение",
				ЭтотОбъект,
				Элемент),
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СправочникВнешниеПользователи(Команда)
	ОткрытьФорму("Справочник.ВнешниеПользователи.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура НастройкиВходаВнешнихПользователей(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказатьНастройкиВнешнихПользователей", Истина);
	
	ОткрытьФорму("ОбщаяФорма.НастройкиВходаПользователей", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеДоступаНаУровнеЗаписей(Команда)
	
	ОткрытьФорму("РегистрСведений" + "." + "ОбновлениеКлючейДоступаКДанным" + "."
		+ "Форма" + "." + "ОбновлениеДоступаНаУровнеЗаписей");
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьДатыЗапретаИзменения(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
		МодульДатыЗапретаИзмененияСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ДатыЗапретаИзмененияСлужебныйКлиент");
		МодульДатыЗапретаИзмененияСлужебныйКлиент.ОткрытьДатыЗапретаИзмененияДанных(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	ИменаКонстант = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Для Каждого ИмяКонстанты Из ИменаКонстант Цикл
		Если ИмяКонстанты <> "" Тогда
			Оповестить("Запись_НаборКонстант", Новый Структура, ИмяКонстанты);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НастройкиСкрытияПДнПриИзменении(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗащитаПерсональныхДанных") Тогда
		МодульЗащитаПерсональныхДанныхКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЗащитаПерсональныхДанныхКлиент");
		МодульЗащитаПерсональныхДанныхКлиент.НастройкиСкрытияПерсональныхДанныхПриИзменении(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОграничиватьДоступНаУровнеЗаписейУниверсальноПриИзмененииЗавершение(Ответ, Элемент) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		НаборКонстант.ОграничиватьДоступНаУровнеЗаписейУниверсально
			= Не НаборКонстант.ОграничиватьДоступНаУровнеЗаписейУниверсально;
		Возврат;
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
	Элементы.ОбновлениеДоступаНаУровнеЗаписей.Видимость =
		Элементы.ОграничиватьДоступНаУровнеЗаписейУниверсально.Видимость
		И НаборКонстант.ОграничиватьДоступНаУровнеЗаписейУниверсально;
	
КонецПроцедуры

&НаКлиенте
Процедура ОграничиватьДоступНаУровнеЗаписейПриИзмененииЗавершение(Ответ, Элемент) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		НаборКонстант.ОграничиватьДоступНаУровнеЗаписей = Не НаборКонстант.ОграничиватьДоступНаУровнеЗаписей;
		Возврат;
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
	Если Не НаборКонстант.ОграничиватьДоступНаУровнеЗаписей Тогда
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВнешнихПользователейПриИзмененииЗавершение(Ответ, Элемент) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		НаборКонстант.ИспользоватьВнешнихПользователей = Не НаборКонстант.ИспользоватьВнешнихПользователей;
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	ИменаКонстант = Новый Массив;
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	НачатьТранзакцию();
	Попытка
		
		ИмяКонстанты = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
		ИменаКонстант.Добавить(ИмяКонстанты);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	УстановитьДоступность(РеквизитПутьКДанным);
	ОбновитьПовторноИспользуемыеЗначения();
	Возврат ИменаКонстант;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
	Если ЧастиИмени.Количество() <> 2 Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяКонстанты = ЧастиИмени[1];
	КонстантаМенеджер = Константы[ИмяКонстанты];
	КонстантаЗначение = НаборКонстант[ИмяКонстанты];
	ТекущееЗначение  = КонстантаМенеджер.Получить();
	Если ТекущееЗначение <> КонстантаЗначение Тогда
		Попытка
			КонстантаМенеджер.Установить(КонстантаЗначение);
		Исключение
			НаборКонстант[ИмяКонстанты] = ТекущееЗначение;
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
	Возврат ИмяКонстанты;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВнешнихПользователей"
	 Или РеквизитПутьКДанным = "" Тогда
		
		ИспользоватьВнешнихПользователей = НаборКонстант.ИспользоватьВнешнихПользователей;
		
		Элементы.ОткрытьВнешниеПользователи.Доступность         = ИспользоватьВнешнихПользователей;
		Элементы.НастройкиВходаВнешнихПользователей.Доступность = ИспользоватьВнешнихПользователей;
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения")
		И (РеквизитПутьКДанным = "НаборКонстант.ИспользоватьДатыЗапретаИзменения"
		Или РеквизитПутьКДанным = "") Тогда
		
		Элементы.НастроитьДатыЗапретаИзменения.Доступность = НаборКонстант.ИспользоватьДатыЗапретаИзменения;
	КонецЕсли;
	
	
	
КонецПроцедуры

#КонецОбласти
