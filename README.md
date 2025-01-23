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




  
