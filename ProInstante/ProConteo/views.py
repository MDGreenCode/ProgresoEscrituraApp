from django.shortcuts import render, redirect
from .forms import ConteoForm
from .models import ConteoDiario
from django.db.models import Sum, Avg
from .models import ConteoDiario, Proyecto

from django.shortcuts import render, get_object_or_404, redirect
from .models import ConteoDiario
from .forms import ConteoForm

# LISTAR
def lista_conteo(request):
    datos = ConteoDiario.objects.all().order_by('-fecha')
    return render(request, 'registro/lista.html', {'datos': datos})


# CREAR
def crear_conteo(request):
    form = ConteoForm(request.POST or None)

    if form.is_valid():
        form.save()
        return redirect('lista')

    return render(request, 'registro/form.html', {'form': form})


# EDITAR
def editar_conteo(request, id):
    conteo = get_object_or_404(ConteoDiario, id=id)
    form = ConteoForm(request.POST or None, instance=conteo)

    if form.is_valid():
        form.save()
        return redirect('lista')

    return render(request, 'registro/form.html', {'form': form})


# ELIMINAR
def eliminar_conteo(request, id):
    conteo = get_object_or_404(ConteoDiario, id=id)

    if request.method == 'POST':
        conteo.delete()
        return redirect('lista')

    return render(request, 'registro/eliminar.html', {'conteo': conteo})



import json

def dashboard(request):
    total_palabras = ConteoDiario.objects.aggregate(Sum('palabras'))['palabras__sum'] or 0
    promedio = ConteoDiario.objects.aggregate(Avg('palabras'))['palabras__avg'] or 0
    total_registros = ConteoDiario.objects.count()

    # Palabras por proyecto
    proyectos = Proyecto.objects.all()
    datos_proyectos = []

    for p in proyectos:
        total = ConteoDiario.objects.filter(proyecto=p).aggregate(Sum('palabras'))['palabras__sum'] or 0
        datos_proyectos.append({
            'nombre': p.nombre,
            'total': total
        })


    nombres = [d['nombre'] for d in datos_proyectos]
    totales = [d['total'] for d in datos_proyectos]

    context = {
        'total_palabras': total_palabras,
        'promedio': round(promedio, 2),
        'total_registros': total_registros,
        'nombres_json': json.dumps(nombres),
        'totales_json': json.dumps(totales),
    }

    return render(request, 'registro/dashboard.html', context)

from django.db.models.functions import TruncDate

datos_dias = ConteoDiario.objects \
    .annotate(dia=TruncDate('fecha')) \
    .values('dia') \
    .annotate(total=Sum('palabras')) \
    .order_by('dia')

from .models import Proyecto
from .forms import ProyectoForm
from django.shortcuts import render, get_object_or_404, redirect

# LISTAR
def lista_proyectos(request):
    proyectos = Proyecto.objects.all()
    return render(request, 'registro/proyectos/lista.html', {'proyectos': proyectos})


# CREAR
def crear_proyecto(request):
    form = ProyectoForm(request.POST or None)

    if form.is_valid():
        form.save()
        return redirect('proyectos')

    return render(request, 'registro/proyectos/form.html', {'form': form})


# EDITAR
def editar_proyecto(request, id):
    proyecto = get_object_or_404(Proyecto, id=id)
    form = ProyectoForm(request.POST or None, instance=proyecto)

    if form.is_valid():
        form.save()
        return redirect('proyectos')

    return render(request, 'registro/proyectos/form.html', {'form': form})


# ELIMINAR
def eliminar_proyecto(request, id):
    proyecto = get_object_or_404(Proyecto, id=id)

    if request.method == 'POST':
        proyecto.delete()
        return redirect('proyectos')

    return render(request, 'registro/proyectos/eliminar.html', {'proyecto': proyecto})

from datetime import timedelta
def grafico_proyecto(request, id):
    proyecto = Proyecto.objects.get(id=id)

    if not proyecto.fecha_inicio or not proyecto.fecha_fin:
        return render(request, 'registro/grafico.html', {})

    dias = (proyecto.fecha_fin - proyecto.fecha_inicio).days

    labels = []
    esperado = []
    real = []

    palabras_dia = proyecto.meta_total / dias if dias > 0 else 0

    total_real = 0

    for i in range(dias + 1):
        fecha = proyecto.fecha_inicio + timedelta(days=i)

        labels.append(str(fecha))

        # esperado acumulado
        esperado.append(int(palabras_dia * i))

        # real acumulado
        palabras = proyecto.conteodiario_set.filter(fecha=fecha)\
            .aggregate(Sum('palabras'))['palabras__sum'] or 0

        total_real += palabras
        real.append(total_real)

    context = {
        'labels': json.dumps(labels),
        'esperado': json.dumps(esperado),
        'real': json.dumps(real),
    }

    return render(request, 'registro/grafico.html', context)