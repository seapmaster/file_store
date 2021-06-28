////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область Служебные

Процедура ДобавитьОшибку(СтруктураОтвета, ОписаниеОшибки, Отказ = Неопределено)
	
	Если Не Отказ = Неопределено Тогда
		СтруктураОтвета.Вставить("Отказ", Отказ);
	КонецЕсли; // Если Не Отказ = Неопределено Тогда
	
	Если Не СтруктураОтвета.Свойство("Error") Тогда
		СтруктураОтвета.Вставить("Error", Новый Массив);
	КонецЕсли; // Если Не СтруктураОтвета.Свойство("Error") Тогда
	
	СтруктураОтвета.Error.Добавить(ОписаниеОшибки);
	
КонецПроцедуры // ДобавитьОшибку

Функция ПрочитатьСтрокуJSON(СтрокаJSON)

	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
	
	Возврат ПрочитатьJSON(ЧтениеJSON)
	
КонецФункции // ПрочитатьСтрокуJSON

Функция СохранитьВременныйФайл(ДвоичныеДанные, РасширениеФайла, Структураответ)
	
	Результат = ПолучитьИмяВременногоФайла(РасширениеФайла);
	
	Попытка 
		ДвоичныеДанные.Записать(Результат);
	Исключение
		Результат = Неопределено;
		ДобавитьОшибку(Структураответ, "Не удалось сохранить временный файл", Истина);
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции // СохранитьВременныйФайл

Функция СеарилизоватьДвоичныеДанные(ДвоичныеДанные, СтруктураОтвет)

	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку();
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("BinaryData", ДвоичныеДанные);
	
	Попытка
		СериализаторXDTO.ЗаписатьJSON(ЗаписьJSON, СтруктураДанные);
		Результат = ЗаписьJSON.Закрыть();
	Исключение
		ДобавитьОшибку(СтруктураОтвет, "Не удалось сеарилизовать ответ", Истина);
		Результат = Неопределено;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции // СеарилизоватьДвоичныеДанные

Функция ДесериализоватьДвоичныеДанные(ДанныеСтрокой, СтруктураОтвет)
	
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(ДанныеСтрокой);
	
	Попытка
		Результат = СериализаторXDTO.ПрочитатьJSON(ЧтениеJSON, Тип("Структура"));
	Исключение
		Результат = Неопределено;
		ДобавитьОшибку(Результат, "Не удалось прочитать данные файла", Истина);
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции // ДесериализоватьДвоичныеДанные

 #КонецОбласти

#Область РаботаСФайлами

Функция ОбработатьПолученныйФайл(СтруктураПараметров, КлиентХранилища, ПутьКФайлу, СтруктураОтвет)
	
	Результат = Истина;
	
	ФайлХранилища = Справочники.Файлы.НайтиФайл(СтруктураПараметров.FileID, КлиентХранилища);
	Если ЗначениеЗаполнено(ФайлХранилища) Тогда
		
		Если Не ОбновитьДанныеФайла(ПутьКФайлу, ФайлХранилища, СтруктураОтвет) Тогда
			Результат = Ложь;
		КонецЕсли; // Если Не ОбновитьДанныеФайла(ПутьКФайлу, ФайлХранилища) Тогда
	
	Иначе
		
		Если Не ДобавитьФайл(КлиентХранилища, ПутьКФайлу, СтруктураПараметров.FileID, СтруктураОтвет) Тогда
			Результат = Ложь;
		КонецЕсли; // Если Не ДобавитьФайл() Тогда

	КонецЕсли; // Если ЗначениеЗаполнено(ФайлХранилища) Тогда
	
	Возврат Результат;
	
КонецФункции // ОбработатьПолученныйФайл

Функция ОбновитьДанныеФайла(ПутьКФайлу, ФайлХранилища, СтруктураОтвет)

	Результат = Истина;
	ПотокВПамяти = Новый ПотокВПамяти;
	ПустыеДанные = ПотокВПамяти.ЗакрытьИПолучитьДвоичныеДанные();

	ДвоичныеДанные = Новый ДвоичныеДанные(ПутьКФайлу);

	ИнформацияОФайле = Новый Структура;
	ИнформацияОФайле.Вставить("АдресФайлаВоВременномХранилище", ПоместитьВоВременноеХранилище(ДвоичныеДанные));
	ИнформацияОФайле.Вставить("АдресВременногоХранилищаТекста", ПоместитьВоВременноеХранилище(ПустыеДанные));
	
	Попытка
		РаботаСФайлами.ОбновитьФайл(ФайлХранилища, ИнформацияОФайле);
	Исключение
		ДобавитьОшибку(СтруктураОтвет, "Не удалось обновить файл", Истина);
		Результат = Ложь;	
	КонецПопытки;
	
	Возврат Результат;

КонецФункции // ОбновитьДанныеФайла

Функция ДобавитьФайл(КлиентХранилища, ПутьКФайлу, FileID, СтруктураОтвет)

	Результат = Истина;

	Файл = РаботаСФайлами.ДобавитьФайлСДиска(КлиентХранилища, ПутьКФайлу, FileID, КлиентХранилища);
	Если Файл = Неопределено Тогда
		ДобавитьОшибку(СтруктураОтвет, "Не удалось поместить файл в хранилище", Истина);
		Результат = Ложь;
	КонецЕсли; // Если Не Файл = Неопределено Тогда
		
	Возврат Результат;

КонецФункции // ДобавитьФайл

Процедура УдалитьВременныйФайл(ПутьКФайлу, СтруктураОтвет)
	Попытка
		УдалитьФайлы(ПутьКФайлу);
	Исключение
		ДобавитьОшибку(СтруктураОтвет, "Временные файлы не удалены");
	КонецПопытки;
КонецПроцедуры // УдалитьВременныйФайл

#КонецОбласти

///////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция GetFile(СтруктураПараметров) Экспорт
	
	Результат = Новый Структура("Отказ", Ложь);
	
	// Обязательные параметры
	Если Не СтруктураПараметров.Свойство("FileID") Тогда
		ДобавитьОшибку(Результат, "Не указан параметр запроса [FileID]", Истина);
		Возврат Результат;
	КонецЕсли; // Если Не СтруктураПараметров.Свойство("FileID") Тогда	

	// Идентификация базы-клиента		
	КлиентХранилища			= Справочники.КлиентыХранилища.НайтиПоПользователю(ПараметрыСеанса.ТекущийПользователь);
	Если Не ЗначениеЗаполнено(КлиентХранилища) Тогда
		ДобавитьОшибку(Результат, "Клиент не зарегистрирован в хранилище файлов", Истина);
		Возврат Результат;
	КонецЕсли; // Если Не ЗначениеЗаполнено(КлиентХранилища) Тогда
		
	// Поиск файла
	Файл = Справочники.Файлы.НайтиФайл(СтруктураПараметров.FileID, КлиентХранилища);
	Если Не ЗначениеЗаполнено(Файл) Тогда
		ДобавитьОшибку(Результат, "Файл отсутствует в хранилище", Истина);
		Возврат Результат;
	КонецЕсли; // Если Не ЗначениеЗаполнено(Файл) Тогда
	
	
	// Подготовка файла в ответу
	ДанныеФайла 	= РаботаСФайлами.ДанныеФайла(Файл);
	ДанныеСтрокой 	= СеарилизоватьДвоичныеДанные(ПолучитьИзВременногоХранилища(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла), Результат);
	Если ДанныеСтрокой = Неопределено Тогда
		Возврат Результат;
	КонецЕсли; // Если ДанныеСтрокой = Неопределено Тогда
		
	Результат.Вставить("Extension", ДанныеФайла.Расширение);
	Результат.Вставить("Data", 		ДанныеСтрокой);
	
	Возврат	Результат;
	
КонецФункции // GetFile

Функция PutFile(СтруктураПараметров) Экспорт
	
	Результат = Новый Структура("Отказ", Ложь);
	
	// FileID
	Если Не СтруктураПараметров.Свойство("FileID") Тогда
		ДобавитьОшибку(Результат, "Не указан параметр запроса [FileID]", Истина);
		Возврат Результат;
	КонецЕсли; // Если Не СтруктураПараметров.Свойство("FileID") Тогда	
	
	// Идентификация базы-клиента		
	КлиентХранилища = Справочники.КлиентыХранилища.НайтиПоПользователю(ПараметрыСеанса.ТекущийПользователь);
	Если Не ЗначениеЗаполнено(КлиентХранилища) Тогда
		ДобавитьОшибку(Результат, "Клиент не зарегистрирован в хранилище файлов", Истина);
		Возврат Результат;
	КонецЕсли; // Если Не ЗначениеЗаполнено(КлиентХранилища) Тогда
	
	// Body		
	Если Не СтруктураПараметров.Свойство("body") Тогда
		ДобавитьОшибку(Результат, "Нет тела запроса", Истина);
		Возврат Результат;
	КонецЕсли; // Если Не СтруктураПараметров.Свойство("body") Тогда
		
	// Data	
	ТелоЗапроса = ПрочитатьСтрокуJSON(СтруктураПараметров.body);
	Если Не ТелоЗапроса.Свойство("Data") Тогда
		ДобавитьОшибку(Результат, "Нет данных для помещения в хранилище файлов", Истина);
		Возврат Результат;
	КонецЕсли; // Если Не ТелоЗапроса.Свойство("Data") Тогда
	
	// Двоичные данные из строки
	ДанныеЗапроса = ДесериализоватьДвоичныеДанные(ТелоЗапроса.Data, Результат); 
	Если ДанныеЗапроса = Неопределено Тогда
		Возврат Результат;
	КонецЕсли; // ДанныеЗапроса = ДесериализоватьДвоичныеДанные(ТелоЗапроса.Data), Результат; 
	
	// BinaryData
	Если Не ДанныеЗапроса.Свойство("BinaryData") Тогда
		ДобавитьОшибку(Результат, "Нет двоичных данных", Истина);
		Возврат Результат;			
	КонецЕсли; // Если Не ТелоЗапроса.Свойство("BinaryData") Тогда
	
	// Extension 
	Если Не ТелоЗапроса.Свойство("Extension") Тогда
		ДобавитьОшибку(Результат, "Не указано расширение файла", Истина);
		Возврат Результат;			
	КонецЕсли; // Если Не ТелоЗапроса.Свойство("Extension") Тогда
					
	// Подготовка временного файла
	ПутьКФайлу = СохранитьВременныйФайл(ДанныеЗапроса.BinaryData, ТелоЗапроса.Extension, Результат);
	Если ПутьКФайлу = Неопределено Тогда
		Возврат Результат;			
	КонецЕсли; // Если ПутьКФайлу = Неопределено Тогда
	
	// Работа с данными файла
	Если Не ОбработатьПолученныйФайл(СтруктураПараметров, КлиентХранилища, ПутьКФайлу, Результат) Тогда
		Возврат Результат;
	КонецЕсли; // Если Не ОбработатьПолученныйФайл(СтруктураПараметров, КлиентХранилища, ПутьКФайлу, Результат) Тогда
	
	// Удаление временного файла
	УдалитьВременныйФайл(ПутьКФайлу, Результат);
	
	Возврат	Результат;
	
КонецФункции // PutFile