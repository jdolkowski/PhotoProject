import webcolors
from rest_framework import serializers
from photo.models import Photo
from colorthief import ColorThief


class PhotoSerializer(serializers.ModelSerializer):

    class Meta:
        model = Photo
        fields = '__all__'
        read_only_fields = ['width', 'height', 'dominant_color_hex']

    def create(self, validated_data):
        photo = Photo.objects.create(**validated_data)
        photo.dominant_color_hex = webcolors.rgb_to_hex(ColorThief(photo.url.path).get_color(quality=1))
        photo.save()
        return photo
