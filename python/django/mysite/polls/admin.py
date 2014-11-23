from django.contrib import admin
from polls.models import Choice, Question

# Register your models here.

class ChoiceInline(admin.TabularInline):
    """docstring for ChoiceInline"""
    
    model = Choice
    extra = 3    
        

class QuestionAdmin(admin.ModelAdmin):
    # fields = ['pub_date', 'question']
    fieldsets = [
        (None, {'fields': ['question']}),
        ('Date information', {'fields': ['pub_date'], 'classes': ['tc']})
    ]

    inlines = [ChoiceInline]

    list_display = ('question', 'pub_date', 'was_published_recently')
    list_filter = ['pub_date']
    search_fields = ['question']
 
 
admin.site.register(Question, QuestionAdmin)
