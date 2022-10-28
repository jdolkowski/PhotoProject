from django.core.validators import MinValueValidator
from django.db import models


class Photo(models.Model):
    title = models.CharField(verbose_name='Title', max_length=255, blank=False)
    album_id = models.PositiveIntegerField(unique=True, blank=False)
    width = models.FloatField(validators=[MinValueValidator(0.1)], blank=True, null=True)
    height = models.FloatField(validators=[MinValueValidator(0.1)], blank=True, null=True)
    dominant_color_hex = models.CharField(max_length=7, default="#ffffff")
    url = models.FileField(upload_to='photo', max_length=254)
