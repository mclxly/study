from django.db import models
from django.utils import timezone
import datetime

# Create your models here.
class Question(models.Model):
    class Meta:
        verbose_name = "Question"
        verbose_name_plural = "Questions"

    def __unicode__(self):
        return "%s,%s" % (self.question, self.pub_date)

    question = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')

    def was_published_recently(self):
        return self.pub_date >= timezone.now() - datetime.timedelta(days=1)
    was_published_recently.admin_order_field = 'pub_date'
    was_published_recently.boolean = True
    was_published_recently.short_description = 'Published recently?'
   

class Choice(models.Model):
    class Meta:
        verbose_name = "Choice"
        verbose_name_plural = "Choices"

    def __unicode__(self):
        return "%s,%d" % (self.choice_text, self.votes)
        # return "%s" % (self.choice_text)

    question = models.ForeignKey(Question)
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)
    