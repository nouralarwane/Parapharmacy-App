from rest_framework import serializers
from boutique.models import Product, Order,Profile, OrderItem, LivraisonAddress, Customer, CartItem, Category
from django.contrib.auth.models import User
from rest_framework import generics

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = "__all__"


class CustomerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Customer
        fields = "__all__"

class CartSerializer(serializers.ModelSerializer):
    # quantity = serializers.IntegerField(source="cartitem.user.cart.quantity")
    class Meta:
        model = CartItem
        fields = "__all__"


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = "__all__"
        

class UserSerializer(serializers.ModelSerializer):
    # id = 
    class Meta:
       model = User
       fields = ["id", "first_name", "last_name", "email", "username", "password"]
       extra_kwargs = {
           "password": {"write_only" : True}
       }

    def create(self, validated_data):
        
        return User.objects.create_user(**validated_data)
    
    

class LoginSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [ "username", "password"]
        


class RegisterSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["first_name", "last_name", "email", "password"]


class ProfileSerializer(serializers.ModelSerializer):
    user_id = serializers.ReadOnlyField(source="user.id")
    first_name = serializers.CharField(source="user.first_name")
    last_name = serializers.CharField(source="user.last_name")
    username = serializers.CharField(source="user.username")
    email = serializers.CharField(source="user.email")
    password = serializers.CharField(source="user.password")

    class Meta:
        model = Profile
        fields = ["user_id","first_name", "last_name", "username", "email", "password", "image"]
        extra_kwargs = {
            "password" : {"write_only" : True}
        }

