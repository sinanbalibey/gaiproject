# Gai

# Translate Project

Bu proje, metin çevirisi yapmak için bir Docker container'ı kullanarak, çeşitli çeviri yöntemleri ve araçlarıyla metinlerin hedef dilde çevrilmesini sağlar. Proje, hem `googletrans` hem de `transformers` kütüphanelerini kullanarak metin çevirisi yapmaktadır.

## Özellikler

- `googletrans` kütüphanesi kullanarak basit metin çevirisi.
- `transformers` kütüphanesi ve Helsinki-NLP modelini kullanarak gelişmiş çeviri.
- Docker container üzerinde çalışacak şekilde yapılandırılmış bir ortam.
- Jupyter Notebook ortamı üzerinden kullanım kolaylığı.

## Başlangıç

## Gereksinimler

Projenin çalışabilmesi için aşağıdaki gereksinimlerin karşılanması gerekir:

- Docker
- Python 3.9 veya üzeri (Eğer Docker kullanmıyorsanız)

## Docker ile kurulum

Proje, Docker ve Docker Compose kullanılarak kolayca çalıştırılabilir. Projeyi kurmak için aşağıdaki adımları izleyebilirsiniz:

1. **Proje dosyasını indirin:**
    
    GitHub reposundan veya yerel bir dizinden proje dosyasını alın.
    
2. **Docker Compose dosyasını kullanarak container başlatın:**
    
    Projeyi çalıştırmak için indirdiğiniz compose dosyasının dizinine gidin ve aşağıdaki komutu kullanın:
    
    ```bash
    docker-compose up -d
    ```
    
    Bu komut, gerekli Docker container'larını başlatacak ve `sibacode/translate` imajını kullanarak bir çeviri ortamı oluşturacaktır.
    

3. Jupyter Notebook'a Erişim:

Çalışan Docker container'ına Jupyter Notebook üzerinden erişebilirsiniz. Web tarayıcınızda şu URL'yi açın:

[http://localhost:8888](http://localhost:8888/)
Giriş için `iamironman` token'ını kullanın.

## Dockerfile Yapılandırması

Aşağıdaki Dockerfile, gerekli bağımlılıkları kurarak çalışma ortamını hazırlar.

```docker
FROM python:3.9-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install sentencepiece

RUN pip install --no-cache-dir jupyter transformers torch

RUN pip install googletrans==4.0.0-rc1

WORKDIR /home/jovyan/work

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=iamironman"]

```

## Çeviri Fonksiyonları

Projede iki farklı çeviri yöntemi mevcuttur: `googletrans` ve `transformers`.

1. `googletrans` ile Çeviri

Aşağıdaki Python fonksiyonu, belirtilen bir dosyadaki metni hedef dile çevirir.

```python
from googletrans import Translator

def translate_text(file_path, target_language='en'):
    with open(file_path, 'r', encoding='utf-8') as file:
        text = file.read()
    
    translator = Translator()
    translated = translator.translate(text, dest=target_language)
    
    return translated.text
```

Bu fonksiyon, `input.txt` dosyasındaki metni alır ve hedef dil olarak `en` (İngilizce) belirler. Çeviri sonucu döndürülür.

2. `transformers` ile Çeviri
Bu fonksiyon, `Helsinki-NLP/opus-mt-tr-en` modelini kullanarak metin çevirisi yapar.

```python
from transformers import pipeline

translator = pipeline("translation", model="Helsinki-NLP/opus-mt-tr-en")

with open("input.txt", "r", encoding="utf-8") as file:
    text = file.read()

print("Çevirilecek Metin:")
print(text)

translation = translator(text)
translated_text = translation[0]['translation_text']

print("Çeviri Sonucu:")
print(translated_text)
```