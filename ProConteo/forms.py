from django import forms
from .models import ConteoDiario
from .models import Proyecto
from django.utils.timezone import now
from django.db.models import Sum, Avg

class ConteoForm(forms.ModelForm):
    class Meta:
        model = ConteoDiario
        fields = ['proyecto','fecha','palabras','comentario']

        widgets = {
            'fecha': forms.DateInput(attrs={'type': 'date', 'class': 'form-control'}),
            'palabras': forms.NumberInput(attrs={'class': 'form-control'}),
            'comentario': forms.Textarea(attrs={'class': 'form-control'}),
            'proyecto': forms.Select(attrs={'class': 'form-control'}),
        }

class ProyectoForm(forms.ModelForm):
    class Meta:
        model = Proyecto
        fields = [
            'nombre', 
            'descripcion',
            'meta_diaria', 
            'meta_total',
            'fecha_inicio',
            'fecha_fin'
        ]

        widgets = {
            'nombre': forms.TextInput(attrs={'class': 'form-control'}),
            'descripcion': forms.Textarea(attrs={'class': 'form-control'}),
            'meta_diaria': forms.NumberInput(attrs={'class': 'form-control'}),
            'meta_total': forms.NumberInput(attrs={'class': 'form-control'}),
            'fecha_inicio': forms.DateInput(attrs={'type': 'date', 'class': 'form-control'}),
            'fecha_fin': forms.DateInput(attrs={'type': 'date', 'class': 'form-control'}),
        }