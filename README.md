# scheduler_mirea

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

ScheduleMIREA предназначено для удобства получения и просмотра расписания, а также для ведения 
записей заданий и их сроках здачи.

Данное приложение состоит из 5 основных страниц:
    Главная страница (домашняя) отображает расписание текущего дня. Каждый предмет явлетятся кнопкой 
и принажати на неё откроется страница с заланиями по этому предмету на текущее число.   
    Страница со списком прдметов. Каждый предмет явдяется кнопкой и при нажатии на неё откроется 
окно со списком всех заданий по выбранному предмету. На странице с выбранным предметом отобраются 
все задания по этому предмету. Каждое задание является кнопкой и при нажатии на неё открывается
окно с редактированием задания. Также в этой вкладке можно удалить задание, загрузить к нему файл
и установить дедлайн.
    Страница с параметрами отображает 2 поля: для ввода группы и поле для ввода дней уведомления
дедлайна.
    Страница с календарём отображает 2 календарных месяца. При нажатии на число открывается вкладка
с расписанием на выбранное число.
    Страница с уведомлениями. На ней отображаются уведомления о приближении дедлайнов сдачи работ.
