# Тестовое задание от Effective Mobile

**Общее описание задания**

* Необходимо разработать простое приложение для ведения списка дел (ToDo List) с
возможностью добавления, редактирования, удаления задач.

**1. Отображение списка задач на главном экране.**
  
 * Задача должна содержать название, описание, дату создания и статус (выполнена/не
выполнена).
 * Возможность добавления новой задачи.
 * Возможность редактирования существующей задачи.
 * Возможность удаления задачи.
 * Возможность поиска по задачам.
   
**2. Загрузка списка задач из dummyjson api: https://dummyjson.com/todos. При первом
запуске приложение должно загрузить список задач из указанного json api.**

**3. Многопоточность:**

* Обработка создания, загрузки, редактирования, удаления и поиска задач должна
выполняться в фоновом потоке с использованием GCD или NSOperation.
* Интерфейс не должен блокироваться при выполнении операций.
  
**4. CoreData:**
  
* Данные о задачах должны сохраняться в CoreData.
* Приложение должно корректно восстанавливать данные при повторном запуске.
  
**5. Используйте систему контроля версий GIT для разработки.**

**6. Напишите юнит-тесты для основных компонентов приложения.**

**7. Необходимо убедиться, что проект открывается на Xcode 15.**

# Работающее приложение https://github.com/user-attachments/assets/0e4a81e0-bb98-4a3a-b29b-9a015b627fd8

**Unit Тестирование**
<img width="1432" alt="Снимок экрана 2025-01-24 в 10 36 00" src="https://github.com/user-attachments/assets/05201446-58d0-48a6-92bd-54f829096164" />

# Работа над замечаниями 
* Не нужно использовать singletone для работы с данными

Исправленно добавлением в coreDataManager протоколов и выноса NSPersistentContainer в appDelegate. Без singletone возникала утечка данных, поскольку не было единого контейнера.


  
