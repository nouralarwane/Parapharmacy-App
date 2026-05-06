from rest_framework.response import Response
from boutique.models import Product, Order, OrderItem, LivraisonAddress, Customer, Cart, CartItem, User, Profile, Category
from rest_framework import viewsets
from .serializers import ProductSerializer, CustomerSerializer, CartSerializer, UserSerializer, LoginSerializer, RegisterSerializer, ProfileSerializer, CategorySerializer
from rest_framework.views import APIView
from rest_framework.decorators import api_view 
from rest_framework import status 
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth import authenticate, login
from rest_framework import filters
from django_filters import rest_framework
from .filters import ProductFilter
from rest_framework import generics
from rest_framework.parsers import MultiPartParser, FormParser
from django.shortcuts import get_object_or_404
# Create your views here.


# Product view
class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    filter_backends = [rest_framework.DjangoFilterBackend]
    # filterset_class = ProductFilter
    # search_fields = ["name", "category__name"]
    

# Product View per category
@api_view(["GET"])
def ProductsPerCategory(request, pk):
    if request.method == "GET":
        products = Product.objects.filter(category_id=pk)
        serializer = ProductSerializer(products, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


# User cart
class UserCart(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # all_carts = CartItem.objects.all()
        user_id = User.objects.get(username=request.user)
        user_cart = Cart.objects.get(user=user_id)
        user_cartItem = CartItem.objects.filter(cart=user_cart)
        serializer = CartSerializer(user_cartItem, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK) 
    
    def post(self, request):
        quantity_to_add = int(request.data.get("quantity"))
                
        product_to_add = Product.objects.get(id=request.data.get("product")) # The product to add to the cart
        
        user_cart = Cart.objects.get(user=request.user.id)
        user_cartItem = CartItem.objects.filter(cart=user_cart) # Getting the user products
        
        # The stock of the product
        if product_to_add.stock < 0:
            return Response({"Error": "Le produit est en rupture de stock!!"}, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            # Check if the product is already in the user cart
            cart_item = CartItem.objects.get(cart__user=request.user, product=product_to_add)
            
            if quantity_to_add > 0:
                cart_item.quantity += quantity_to_add
                cart_item.save()
                product_to_add.stock -= quantity_to_add
                product_to_add.save()
                return Response({"Success ": "On augmente la quantité du produit dans le panier","La nouvelle quantité du produit: ":cart_item.quantity}, status=status.HTTP_201_CREATED)

            else:
                return Response({"Error" : f"La quantité doit être supérieure à Zero: panier de {user_cart.id}"}, status=status.HTTP_400_BAD_REQUEST)

        except CartItem.DoesNotExist:
            # The product is not in the cart
            if quantity_to_add > 0:
                print(f" On ajoute le nouveau produit dans le panier")
                # On crée l'objet manuellement 
                new_item = CartItem.objects.create(
                    cart=user_cart,
                    product=product_to_add,
                    quantity=quantity_to_add
                )
                
                product_to_add.stock -= quantity_to_add
                product_to_add.save()
                
                serializer = CartSerializer(new_item)
                
                return Response({"Success Adding product" : "Produit ajouté avec succès!!", "Data": serializer.data}, status=status.HTTP_201_CREATED)

            else:
                print(f" On ajoute le nouveau produit dans le panier")
                # On crée l'objet manuellement 
                new_item = CartItem.objects.create(
                    cart=user_cart,
                    product=product_to_add,
                    quantity=1
                )
                
                product_to_add.stock -= 1
                product_to_add.save()
                
                serializer = CartSerializer(new_item)
                
                return Response({"Success": "Un seul produit ajouté dans le panier!!"}, status=404)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
 
# User product deleting
class UserCartDelete(viewsets.ViewSet):
    
    def destroy(self,request, pk):
        product_to_reduce = Product.objects.get(id=pk)
        # quantity_cart = int(request.data.get("quantity"))
        # cart item to delete
        try:
            cart_item = CartItem.objects.get(cart__user=request.user, product=product_to_reduce)
        except CartItem.DoesNotExist:
            return Response({"Error": "Product not found in your cart"}, status=404)
        
        product_to_reduce.stock += cart_item.quantity
        product_to_reduce.save()
        cart_item.delete()
        
        return Response({"Message" : "Success","New stock" : product_to_reduce.stock}, status=status.HTTP_200_OK)

			
    def reduce(self, request, pk):
            product_to_reduce = Product.objects.get(id=pk)
            product_serializer = ProductSerializer(product_to_reduce)

            # Getting the user products
            user_cart = Cart.objects.get(user=request.user.id)
            user_cartItem = CartItem.objects.filter(cart=user_cart) 
            serializer = CartSerializer(data=user_cartItem, many=True)
            print(user_cartItem)
            quantity_remove = int(request.data.get("quantity"))

            # Getting the cart of the product to delete
            try:
                cart_item = CartItem.objects.get(cart__user=request.user, product=product_to_reduce)
            except CartItem.DoesNotExist:
                return Response({"Error": "Product not found in your cart"}, status=404)
            

            if int(quantity_remove) == 0 or quantity_remove is None: # Check the quantity sent
                return Response({"Error": "Please put a positive value!!"}, status=status.HTTP_200_OK)
            
            if int(quantity_remove) > int(cart_item.quantity): # Check if the request quantity is not greater than the real one
                return Response({"Error" : "You can't reduce or delete this product, the value is beyond the real quantity!!"})
            
            if int(quantity_remove) == int(cart_item.quantity) : # Check if the user wants to destroy this product from the cart
                return Response({"Message": "You want to delete definitely this product from your cart ?"})
            
            # Here we're going to reduce the quantity in the cart 
            cart_item.quantity = cart_item.quantity - quantity_remove
            cart_item.save()

            product_to_reduce.stock += quantity_remove
            product_to_reduce.save()
            
            return Response({"Success": "It's perfect!!!", "New quantity": cart_item.quantity, "product_stock": product_to_reduce.stock},status=status.HTTP_200_OK)
        

#User view
class UserView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        users = User.objects.all()
        serializer = UserSerializer(users, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK) 
    
    
    def post(self, request):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)    


# Profile
class ProfileView(generics.ListAPIView, generics.RetrieveDestroyAPIView):
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer


# Profile image updating
class ProfileImageUpdate(APIView):
    parser_classes = (MultiPartParser, FormParser) # Obligatoire pour les images
    permission_classes = [IsAuthenticated]

    def post(self, request):

        profile = request.user.profile
        if "image" in request.FILES:
            profile.image = request.FILES.get("image")
            profile.save()
            return Response({"Succès"}, status=200) 
        else:
            return Response({"Erreur d'uploading!!!"},status=404)


# Custom registration and updating
class CustomerView(viewsets.ModelViewSet):
    queryset = Customer.objects.all()
    serializer_class = CustomerSerializer


# Categories view
class CategoryView(viewsets.ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer    


