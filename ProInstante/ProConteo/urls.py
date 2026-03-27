from django.urls import path
from . import views

urlpatterns = [
    path('', views.lista_conteo, name='lista'),
    path('nuevo/', views.crear_conteo, name='nuevo'),
    path('editar/<int:id>/', views.editar_conteo, name='editar'),
    path('eliminar/<int:id>/', views.eliminar_conteo, name='eliminar'),
    path('dashboard/', views.dashboard, name='dashboard'),
    path('proyectos/', views.lista_proyectos, name='proyectos'),
    path('proyectos/nuevo/', views.crear_proyecto, name='crear_proyecto'),
    path('proyectos/editar/<int:id>/', views.editar_proyecto, name='editar_proyecto'),
    path('proyectos/eliminar/<int:id>/', views.eliminar_proyecto, name='eliminar_proyecto'),
    path('grafico/<int:id>/', views.grafico_proyecto, name='grafico_proyecto'),
]