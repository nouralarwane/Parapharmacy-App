from django.contrib import admin

from .models import Category,Customer, Product, Order, OrderItem, LivraisonAddress, Cart, CartItem, Profile, User
# Register your models here.

admin.site.register(Category)
admin.site.register(Customer)
admin.site.register(Product)
admin.site.register(Order)
admin.site.register(OrderItem)
admin.site.register(LivraisonAddress)
admin.site.register(CartItem)
admin.site.register(Cart)
admin.site.register(Profile)
