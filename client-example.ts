// Пример использования сгенерированного TypeScript клиента
import { ProductServiceClient } from "./gen/typescript/prod_service/products/v1/ServiceServiceClientPb";
import {
  CreateProductRequest,
  AllProductsRequest,
  CreateProductResponse,
  AllProductsResponse,
} from "./gen/typescript/prod_service/products/v1/service_pb";

// Создание клиента
const client = new ProductServiceClient("http://localhost:8080", null, null);

// Функция для создания продукта
async function createProduct(
  name: string,
  description: string,
  price: string
): Promise<CreateProductResponse> {
  return new Promise((resolve, reject) => {
    const request = new CreateProductRequest();
    request.setName(name);
    request.setDescription(description);
    request.setPrice(price);
    request.setCurrencyId(1);
    request.setRating(5);
    request.setCategoryId("electronics");
    request.setSpecification("Sample specification");

    client.createProduct(request, {}, (err, response) => {
      if (err) {
        reject(err);
      } else {
        resolve(response);
      }
    });
  });
}

// Функция для получения всех продуктов
async function getAllProducts(): Promise<AllProductsResponse> {
  return new Promise((resolve, reject) => {
    const request = new AllProductsRequest();

    client.allProducts(request, {}, (err, response) => {
      if (err) {
        reject(err);
      } else {
        resolve(response);
      }
    });
  });
}

// Пример использования
async function example() {
  try {
    // Создание продукта
    const createResponse = await createProduct(
      "iPhone 15",
      "Latest Apple smartphone",
      "999"
    );
    console.log("Product created:", createResponse.getProduct());

    // Получение всех продуктов
    const allProductsResponse = await getAllProducts();
    console.log("All products:", allProductsResponse.getProductList());
  } catch (error) {
    console.error("Error:", error);
  }
}

// Экспорт функций для использования в других модулях
export { createProduct, getAllProducts, ProductServiceClient };
