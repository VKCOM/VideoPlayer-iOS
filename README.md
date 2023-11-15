<p align="center">
  <img src="https://github.com/VKCOM/VideoPlayer-iOS/assets/15659755/9a5101ce-c805-4ac8-835d-cd71ebb79e40" width="96" alt="Video Player SDK logo" />
</p>
<p align="center">
  Плеер для видео и трансляций на платформе VK Видео.
</p>
<p align="center">
  <a href="https://vk.com/video-sdk" title="Информация об инфраструктуре и SDK">SDK и инфраструктура</a> · <a href="https://vkcom.github.io/VideoPlayer-iOS/documentation/ovkit/" title="Документация к SDK">Документация</a>
</p>

---

SDK состоит из нескольких фреймворков, среди них ключевыми являются три:
* `OVPlayerKit` - ядро плеера, отвечает за проигрывание;
* `OVKit` - модульная UI-обертка над ядром;
* `OVKResources` - динамический фреймворк с ресурсами для `OVKit`.

SDK является коробочным решением и одновременно предоставляет возможность полностью изменять внешний вид плеера. Среди основных возможностей можно выделить:
* Воспроизведение видео и прямых трансляций платформы VK Видео;
* Полноэкранный режим;
* Картинка в картинке внутри и снаружи приложения;
* Готовый набор UI-контролов и поведения для них;
* Скачивание видео и оффлайн-проигрывание;
* Фоновое проигрывание.

## Установка и начало работы

### Swift Package Manager
Добавьте зависимость от VideoPlayer-iOS в `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/VKCOM/VideoPlayer-iOS.git", .upToNextMajor(from: "1.74.0"))
]
```

## Пример интеграции и быстрый старт

Описание шагов интеграции находится в [инструкции по быстрому старту](https://vkcom.github.io/VideoPlayer-iOS/documentation/ovkit/quickstart). В репозитории есть демо-приложение, которое на примере показывает интеграцию SDK и его основные возможности. 
