from django.urls import path, include
from . import views
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView



# Products route
productRouter = DefaultRouter()
productRouter.register(r"products", views.ProductViewSet, basename="products")

# Users profile route
profileRouter = DefaultRouter()
profileRouter.register(r"profiles", views.ProfileView, basename="profiles")

# Customer route
customerRouter = DefaultRouter()
customerRouter.register(r"customers", views.CustomerView, basename="customers")

# Users profile route
CategoryRouter = DefaultRouter()
CategoryRouter.register(r"categories", views.CategoryView, basename="categories")

urlpatterns = [
    path("", include(productRouter.urls)), # Products
    
    # path("", include(profileRouter.urls)), # Profiles

    path("", include(customerRouter.urls)), # Customers
    
    path("", include(CategoryRouter.urls)), # Categories

    path("produits/<int:pk>", views.ProductsPerCategory, name="produits"), # Getting products by category

    path("cart/", views.UserCart.as_view()), # Users cart
    
    path("users/", views.UserView.as_view()), # Users

    path("cart/remove/<int:pk>/", views.UserCartDelete.as_view({'post' : "reduce"})), # User cart item reduce 
    
    path("cart/destroy/<int:pk>/", views.UserCartDelete.as_view({'post' : "destroy"})), # User cart item destroy
    
    path("profiles/", views.ProfileView.as_view(), name="profiles"), # Users profile

    path("profileUpdate/", views.ProfileImageUpdate.as_view(), name="profile_update"), # Profile Updating



    path("token/", TokenObtainPairView.as_view(), name="token_obtain_pair"),

    path("token/refresh/", TokenRefreshView.as_view(), name="token_refresh"),




    
]


