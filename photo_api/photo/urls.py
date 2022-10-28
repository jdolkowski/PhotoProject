from rest_framework.routers import DefaultRouter
from django.urls import path, include
from photo.views import PhotoViewSet

router = DefaultRouter()
router.register(r'photos', PhotoViewSet, basename='photo')

urlpatterns = [
    path('', include(router.urls)),
]
