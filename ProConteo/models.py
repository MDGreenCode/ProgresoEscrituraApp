from django.db import models
from django.utils.timezone import now
from django import forms
from datetime import timedelta, date
from django.db.models import Avg

class Proyecto(models.Model):
    nombre = models.CharField(max_length=200)
    descripcion = models.TextField(blank=True)

    meta_diaria = models.IntegerField(default=0)
    meta_total = models.IntegerField(default=0)

    fecha_inicio = models.DateField(null=True, blank=True)
    fecha_fin = models.DateField(null=True, blank=True)
    
    def total_palabras(self):
        return sum(c.palabras for c in self.conteodiario_set.all())

    def progreso(self):
        if self.meta_total > 0:
            return (self.total_palabras() / self.meta_total) * 100
        return 0

    def estado(self):
        hoy = now().date()

        if self.fecha_fin:
            if hoy > self.fecha_fin:
                return "Atrasado"
            elif hoy >= self.fecha_inicio:
                return "En progreso"
        return "Pendiente"

    def dias_restantes(self):
        if self.fecha_fin:
            hoy = date.today()
            return (self.fecha_fin - hoy).days
        return None

    def palabras_restantes(self):
        if self.meta_total > 0:
            return max(self.meta_total - self.total_palabras(), 0)
        return 0

    def velocidad_necesaria(self):
        dias = self.dias_restantes()
        palabras = self.palabras_restantes()

        if dias and dias > 0:
            return round(palabras / dias, 2)
        return 0
    def fecha_prediccion(self):
        # Promedio real de palabras por día
        registros = self.conteodiario_set.all()

        if not registros.exists():
            return None

        promedio = registros.aggregate(Avg('palabras'))['palabras__avg']

        if not promedio or promedio == 0:
            return None

        palabras_restantes = self.palabras_restantes()

        dias_necesarios = palabras_restantes / promedio

        return date.today() + timedelta(days=int(dias_necesarios))
    def __str__(self):
        return self.nombre


class ConteoDiario(models.Model):
    proyecto = models.ForeignKey(Proyecto, on_delete=models.CASCADE)
    fecha = models.DateField()
    palabras = models.IntegerField()
    comentario = models.TextField(blank=True)

    def __str__(self):
        return f"{self.proyecto} - {self.fecha}"